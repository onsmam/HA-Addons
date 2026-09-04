#!/bin/sh
set -e

ENCRYPTION_KEY=$(jq -r '.encryption_key' /data/options.json)
DB_PASSWORD=$(jq -r '.db_password' /data/options.json)
MQTT_HOST=$(jq -r '.mqtt_host' /data/options.json)
MQTT_PORT=$(jq -r '.mqtt_port' /data/options.json)
GRAFANA_URL=$(jq -r '.grafana_url' /data/options.json)
HA_DISCOVERY=$(jq -r '.mqtt_ha_discovery' /data/options.json)
HA_DISCOVERY_URL=$(jq -r '.mqtt_ha_discovery_url' /data/options.json)
HA_DISCOVERY_PREFIX=$(jq -r '.mqtt_ha_discovery_prefix' /data/options.json)

export ENCRYPTION_KEY="${ENCRYPTION_KEY}"
export DATABASE_HOST=localhost
export DATABASE_USER=teslamate
export DATABASE_PASS="${DB_PASSWORD}"
export DATABASE_NAME=teslamate
export MQTT_HOST="${MQTT_HOST}"
export MQTT_PORT="${MQTT_PORT}"
export GRAFANA_URL="${GRAFANA_URL}"
export MQTT_HOME_ASSISTANT_DISCOVERY="${HA_DISCOVERY}"
export MQTT_HOME_ASSISTANT_DISCOVERY_PREFIX="${HA_DISCOVERY_PREFIX}"
export VIRTUAL_HOST=0.0.0.0
export CHECK_ORIGIN=false
export PORT=4000

if [ "${HA_DISCOVERY_URL}" != "null" ] && [ -n "${HA_DISCOVERY_URL}" ]; then
    export MQTT_HOME_ASSISTANT_DISCOVERY_URL="${HA_DISCOVERY_URL}"
fi

cd /opt/app

echo "[teslamate] Database migreren..."
bin/teslamate eval "TeslaMate.Release.migrate()"

echo "[teslamate] MQTT_HOME_ASSISTANT_DISCOVERY=${MQTT_HOME_ASSISTANT_DISCOVERY}"
echo "[teslamate] MQTT_HOME_ASSISTANT_DISCOVERY_PREFIX=${MQTT_HOME_ASSISTANT_DISCOVERY_PREFIX}"
echo "[teslamate] Starten..."
exec /entrypoint.sh bin/teslamate start
