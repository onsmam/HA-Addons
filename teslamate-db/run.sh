#!/bin/sh
set -e

DB_PASSWORD=$(jq -r '.db_password' /data/options.json)

export POSTGRES_USER=teslamate
export POSTGRES_PASSWORD="${DB_PASSWORD}"
export POSTGRES_DB=teslamate
export PGDATA="/share/teslamate/db"

mkdir -p "${PGDATA}"

echo "[teslamate-db] PostgreSQL starten met data in ${PGDATA}..."
exec docker-entrypoint.sh postgres
