#!/bin/sh
set -e

CONFIG_PATH=$(jq -r '.config_path' /data/options.json)
CONFIG_DIR=$(dirname "${CONFIG_PATH}")
PERSISTENCE_DIR="${CONFIG_DIR}/persistence"

mkdir -p "${PERSISTENCE_DIR}"
chmod 777 "${PERSISTENCE_DIR}"

# Maak ook /share/mosquitto/persistance/ aan voor gebruikers die dat pad in hun config hebben
mkdir -p "${CONFIG_DIR}/persistance"
chmod 777 "${CONFIG_DIR}/persistance"

if [ ! -f "${CONFIG_PATH}" ]; then
    echo "[mosquitto-custom] Geen config gevonden op ${CONFIG_PATH}, standaard config aanmaken..."
    cat > "${CONFIG_PATH}" << EOF
# Mosquitto standaard configuratie
# Zie https://mosquitto.org/man/mosquitto-conf-5.html voor alle opties

listener 1883
allow_anonymous true

persistence true
persistence_location ${PERSISTENCE_DIR}/

log_dest stdout
EOF
fi

echo "[mosquitto-custom] Mosquitto starten met config: ${CONFIG_PATH}"
exec mosquitto -c "${CONFIG_PATH}"
