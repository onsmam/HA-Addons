#!/bin/sh
set -e

ENCRYPTION_KEY=$(jq -r '.encryption_key' /data/options.json)
DB_PASSWORD=$(jq -r '.db_password' /data/options.json)
MQTT_HOST=$(jq -r '.mqtt_host' /data/options.json)
MQTT_PORT=$(jq -r '.mqtt_port' /data/options.json)

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

cd /opt/app

echo "[teslamate] Database migreren..."
bin/teslamate eval "TeslaMate.Release.migrate()"

echo "[teslamate] Starten..."
exec /entrypoint.sh bin/teslamate start
