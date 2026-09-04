#!/bin/sh
set -e

DB_PASSWORD=$(jq -r '.db_password' /data/options.json)
ADMIN_PASSWORD=$(jq -r '.admin_password' /data/options.json)

SHARE_DIR="/share/teslamate/grafana"
mkdir -p "${SHARE_DIR}/data" "${SHARE_DIR}/logs" "${SHARE_DIR}/plugins"

chown -R 472:0 "${SHARE_DIR}"

export DATABASE_HOST=localhost
export DATABASE_PORT=5432
export DATABASE_NAME=teslamate
export DATABASE_USER=teslamate
export DATABASE_PASS="${DB_PASSWORD}"
export GF_PATHS_DATA="${SHARE_DIR}/data"
export GF_PATHS_LOGS="${SHARE_DIR}/logs"
export GF_PATHS_PLUGINS="${SHARE_DIR}/plugins"
export GF_SECURITY_ADMIN_PASSWORD="${ADMIN_PASSWORD}"
export GF_SERVER_HTTP_PORT=3001
export GF_ANALYTICS_REPORTING_ENABLED=false
export GF_SECURITY_ALLOW_EMBEDDING=true

echo "[teslamate-grafana] Grafana starten..."
exec grafana server \
    --homepath=/usr/share/grafana \
    --config=/etc/grafana/grafana.ini \
    --packaging=docker
