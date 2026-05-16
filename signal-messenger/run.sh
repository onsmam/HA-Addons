#!/bin/sh
set -e

MODE=$(jq -r '.mode' /data/options.json)
AUTO_RECEIVE=$(jq -r '.auto_receive' /data/options.json)
CMD_TIMEOUT=$(jq -r '.cmd_timeout' /data/options.json)
LOG_LEVEL=$(jq -r '.log_level' /data/options.json)

export MODE="${MODE}"
export AUTO_RECEIVE="${AUTO_RECEIVE}"
export SIGNAL_CLI_CMD_TIMEOUT="${CMD_TIMEOUT}"
export LOG_LEVEL="${LOG_LEVEL}"
export SIGNAL_CLI_CONFIG_DIR="/addon_configs/signal_messenger"
export PORT="8080"

echo "[signal-messenger] Starten in ${MODE} modus"
exec /entrypoint.sh
