#!/bin/sh
set -e

ENCRYPTION_KEY=$(jq -r '.encryption_key' /data/options.json)
DB_PASSWORD=$(jq -r '.db_password' /data/options.json)
MQTT_HOST=$(jq -r '.mqtt_host' /data/options.json)
MQTT_PORT=$(jq -r '.mqtt_port' /data/options.json)
GRAFANA_PASSWORD=$(jq -r '.grafana_password' /data/options.json)

DATA_DIR="/share/teslamate"
mkdir -p "${DATA_DIR}/db"
mkdir -p "${DATA_DIR}/grafana/data"
mkdir -p "${DATA_DIR}/grafana/logs"
mkdir -p "${DATA_DIR}/grafana/plugins"
mkdir -p "${DATA_DIR}/grafana/provisioning/datasources"
mkdir -p "${DATA_DIR}/grafana/provisioning/dashboards"
mkdir -p "${DATA_DIR}/grafana/dashboards"

cat > "${DATA_DIR}/grafana/provisioning/datasources/teslamate.yml" << YAML
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

cat > "${DATA_DIR}/grafana/provisioning/dashboards/teslamate.yml" << YAML
apiVersion: 1
providers:
  - name: TeslaMate
    type: file
    disableDeletion: false
    updateIntervalSeconds: 30
    options:
      path: ${DATA_DIR}/grafana/dashboards
      foldersFromFilesStructure: true
YAML

if [ ! "$(ls -A ${DATA_DIR}/grafana/dashboards 2>/dev/null)" ]; then
    echo "[teslamate] Grafana dashboards downloaden..."
    BASE_URL="https://raw.githubusercontent.com/adriankumpf/teslamate/master/grafana/dashboards"
    for DASH in battery-health charging-details charging-stats charge-level drive-details drives efficiency mileage projected-range states updates vampire-drain visited-geofences overview; do
        curl -sS -o "${DATA_DIR}/grafana/dashboards/${DASH}.json" "${BASE_URL}/${DASH}.json" 2>/dev/null || true
    done
fi

chown -R 472:0 "${DATA_DIR}/grafana"

export POSTGRES_USER=teslamate
export POSTGRES_PASSWORD="${DB_PASSWORD}"
export POSTGRES_DB=teslamate
export PGDATA="${DATA_DIR}/db"
export ENCRYPTION_KEY="${ENCRYPTION_KEY}"
export DATABASE_HOST=localhost
export DATABASE_USER=teslamate
export DATABASE_PASS="${DB_PASSWORD}"
export DATABASE_NAME=teslamate
export MQTT_HOST="${MQTT_HOST}"
export MQTT_PORT="${MQTT_PORT}"
export VIRTUAL_HOST=localhost
export CHECK_ORIGIN=false
export PORT=4000
export GF_PATHS_DATA="${DATA_DIR}/grafana/data"
export GF_PATHS_LOGS="${DATA_DIR}/grafana/logs"
export GF_PATHS_PLUGINS="${DATA_DIR}/grafana/plugins"
export GF_PATHS_PROVISIONING="${DATA_DIR}/grafana/provisioning"
export GF_SECURITY_ADMIN_PASSWORD="${GRAFANA_PASSWORD}"
export GF_SERVER_HTTP_PORT=3000
export GF_ANALYTICS_REPORTING_ENABLED=false
export GF_SECURITY_ALLOW_EMBEDDING=true

echo "[teslamate] Starten met supervisord..."
exec supervisord -c /etc/supervisor/conf.d/teslamate.conf
