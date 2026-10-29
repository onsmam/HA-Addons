#!/bin/sh
# Healthcheck draait buiten run.sh; poort daarom uit de opties lezen
PORT=$(jq -r '.port' /data/options.json)
export PORT
exec /app/bin/airtrail-healthcheck
