#!/bin/bash
set -e

CONFIG_PATH=$(bashio::config 'config_path')

if [ ! -f "${CONFIG_PATH}" ]; then
    echo "Config file not found at ${CONFIG_PATH}"
    echo "Creating default config at ${CONFIG_PATH}"
    mkdir -p "$(dirname "${CONFIG_PATH}")"
    cat > "${CONFIG_PATH}" << 'EOF'
# Default Mosquitto configuration
# See https://mosquitto.org/man/mosquitto-conf-5.html for all options

listener 1883
allow_anonymous true

persistence true
persistence_location /data/mosquitto/

log_dest stdout
EOF
fi

echo "Starting Mosquitto with config: ${CONFIG_PATH}"
exec mosquitto -c "${CONFIG_PATH}"
