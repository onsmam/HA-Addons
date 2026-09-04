#!/bin/sh
set -e

DB_PASSWORD=$(jq -r '.db_password' /data/options.json)
ADMIN_PASSWORD=$(jq -r '.admin_password' /data/options.json)

SHARE_DIR="/share/teslamate/grafana"
mkdir -p "${SHARE_DIR}/data" "${SHARE_DIR}/logs" "${SHARE_DIR}/plugins"
mkdir -p "${SHARE_DIR}/provisioning/datasources"
mkdir -p "${SHARE_DIR}/provisioning/dashboards"
mkdir -p "${SHARE_DIR}/provisioning/plugins"
mkdir -p "${SHARE_DIR}/provisioning/alerting"
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

TESLAMATE_VERSION=$(jq -r '.teslamate_version // "main"' /data/options.json)
echo "[teslamate-grafana] Dashboards downloaden voor Teslamate ${TESLAMATE_VERSION}..."
BASE_URL="https://raw.githubusercontent.com/teslamate-org/teslamate/${TESLAMATE_VERSION}/grafana/dashboards"
for DASH in battery-health charging-details charging-stats charge-level drive-details drives efficiency mileage projected-range states updates vampire-drain visited-geofences overview; do
    DASH_FILE="${SHARE_DIR}/dashboards/${DASH}.json"
    echo "[teslamate-grafana] Downloaden: ${DASH}.json"
    curl -sS -o "${DASH_FILE}.tmp" "${BASE_URL}/${DASH}.json" 2>/dev/null && \
    jq -e '.title' "${DASH_FILE}.tmp" > /dev/null 2>&1 && \
    mv "${DASH_FILE}.tmp" "${DASH_FILE}" || \
    { echo "[teslamate-grafana] Mislukt: ${DASH}.json"; rm -f "${DASH_FILE}.tmp"; }
done

export GF_PATHS_DATA="${SHARE_DIR}/data"
export GF_PATHS_LOGS="${SHARE_DIR}/logs"
export GF_PATHS_PLUGINS="${SHARE_DIR}/plugins"
export GF_PATHS_PROVISIONING="${SHARE_DIR}/provisioning"
export GF_SECURITY_ADMIN_PASSWORD="${ADMIN_PASSWORD}"
export GF_SERVER_HTTP_PORT=3001
export GF_ANALYTICS_REPORTING_ENABLED=false
export GF_SECURITY_ALLOW_EMBEDDING=true

echo "[teslamate-grafana] Grafana starten..."
exec /usr/share/grafana/bin/grafana server \
    --homepath=/usr/share/grafana \
    --config=/etc/grafana/grafana.ini \
    --packaging=docker
