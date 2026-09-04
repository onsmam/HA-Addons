#!/bin/sh
set -e

DB_PASSWORD=$(jq -r '.db_password' /data/options.json)
ADMIN_PASSWORD=$(jq -r '.admin_password' /data/options.json)

SHARE_DIR="/share/teslamate/grafana"
mkdir -p "${SHARE_DIR}/data" "${SHARE_DIR}/logs" "${SHARE_DIR}/plugins"
mkdir -p "${SHARE_DIR}/provisioning/datasources"
mkdir -p "${SHARE_DIR}/provisioning/dashboards"
mkdir -p "${SHARE_DIR}/dashboards"

chown -R 472:0 "${SHARE_DIR}"

cat > "${SHARE_DIR}/provisioning/datasources/teslamate.yml" << YAML
apiVersion: 1
datasources:
  - name: TeslaMate
    type: postgres
    url: localhost:5432
    database: teslamate
    user: teslamate
    secureJsonData:
      password: "${DB_PASSWORD}"
    jsonData:
      sslmode: disable
      postgresVersion: 1700
      timescaledb: false
YAML

cat > "${SHARE_DIR}/provisioning/dashboards/teslamate.yml" << YAML
apiVersion: 1
providers:
  - name: TeslaMate
    type: file
    disableDeletion: false
    updateIntervalSeconds: 30
    options:
      path: ${SHARE_DIR}/dashboards
      foldersFromFilesStructure: true
YAML

if [ ! "$(ls -A ${SHARE_DIR}/dashboards 2>/dev/null)" ]; then
    echo "[teslamate-grafana] Dashboards downloaden..."
    BASE_URL="https://raw.githubusercontent.com/adriankumpf/teslamate/master/grafana/dashboards"
    for DASH in battery-health charging-details charging-stats charge-level drive-details drives efficiency mileage projected-range states updates vampire-drain visited-geofences overview; do
        curl -sS -o "${SHARE_DIR}/dashboards/${DASH}.json" "${BASE_URL}/${DASH}.json" 2>/dev/null || true
    done
fi

export GF_PATHS_DATA="${SHARE_DIR}/data"
export GF_PATHS_LOGS="${SHARE_DIR}/logs"
export GF_PATHS_PLUGINS="${SHARE_DIR}/plugins"
export GF_PATHS_PROVISIONING="${SHARE_DIR}/provisioning"
export GF_SECURITY_ADMIN_PASSWORD="${ADMIN_PASSWORD}"
export GF_SERVER_HTTP_PORT=3000
export GF_ANALYTICS_REPORTING_ENABLED=false
export GF_SECURITY_ALLOW_EMBEDDING=true

echo "[teslamate-grafana] Grafana starten..."
exec /usr/share/grafana/bin/grafana server \
    --homepath=/usr/share/grafana \
    --config=/etc/grafana/grafana.ini \
    --packaging=docker
