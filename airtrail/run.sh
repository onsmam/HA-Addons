#!/bin/sh
set -e

PORT=$(jq -r '.port' /data/options.json)
ORIGIN=$(jq -r '.origin' /data/options.json)
TESLAMATE_DB_PASSWORD=$(jq -r '.teslamate_db_password' /data/options.json)
AIRTRAIL_DB_PASSWORD=$(jq -r '.airtrail_db_password' /data/options.json)
# Wachtwoord URL-encoden zodat speciale tekens DB_URL niet breken
AIRTRAIL_DB_PASSWORD_URI=$(jq -r '.airtrail_db_password | @uri' /data/options.json)

DB_HOST=localhost
DB_PORT=5432
UPLOAD_DIR="/share/airtrail/uploads"

mkdir -p "${UPLOAD_DIR}"

until pg_isready -h "${DB_HOST}" -p "${DB_PORT}" -U teslamate >/dev/null 2>&1; do
    echo "[airtrail] Wachten op Teslamate Database addon..."
    sleep 2
done

# Eigen user en database aanmaken in dezelfde PostgreSQL als Teslamate.
# Alleen CREATE als ze nog niet bestaan; de teslamate database wordt niet aangeraakt.
echo "[airtrail] Database 'airtrail' controleren..."
export PGPASSWORD="${TESLAMATE_DB_PASSWORD}"
export PGOPTIONS="-c client_min_messages=warning"
psql -h "${DB_HOST}" -p "${DB_PORT}" -U teslamate -d postgres -v ON_ERROR_STOP=1 -q \
    -v pw="${AIRTRAIL_DB_PASSWORD}" <<'SQL'
SELECT format('CREATE ROLE airtrail LOGIN PASSWORD %L', :'pw')
WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'airtrail')\gexec
SELECT format('ALTER ROLE airtrail WITH LOGIN NOSUPERUSER PASSWORD %L', :'pw')\gexec
SELECT 'CREATE DATABASE airtrail OWNER airtrail'
WHERE NOT EXISTS (SELECT 1 FROM pg_database WHERE datname = 'airtrail')\gexec
SQL
# unaccent is nodig voor de AirTrail migraties; als superuser aanmaken
psql -h "${DB_HOST}" -p "${DB_PORT}" -U teslamate -d airtrail -v ON_ERROR_STOP=1 -q \
    -c 'CREATE EXTENSION IF NOT EXISTS "unaccent";'
unset PGPASSWORD PGOPTIONS

export DB_URL="postgres://airtrail:${AIRTRAIL_DB_PASSWORD_URI}@${DB_HOST}:${DB_PORT}/airtrail"
export ORIGIN="${ORIGIN}"
export PORT="${PORT}"
export UPLOAD_LOCATION="${UPLOAD_DIR}"

echo "[airtrail] Starten op poort ${PORT} (origin ${ORIGIN})..."
cd /app
exec /app/bin/entrypoint.sh
