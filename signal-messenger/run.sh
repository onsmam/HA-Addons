#!/bin/sh
set -e

OPTIONS=/data/options.json

MODE=$(jq -r '.mode // "native"' "$OPTIONS")
CMD_TIMEOUT=$(jq -r '.cmd_timeout // empty' "$OPTIONS")
LOG_LEVEL=$(jq -r '.log_level // "info"' "$OPTIONS")
AUTO_RECEIVE_SCHEDULE=$(jq -r '.auto_receive_schedule // empty' "$OPTIONS")

export MODE
export LOG_LEVEL
export PORT="8080"
export SIGNAL_CLI_CONFIG_DIR="/config"
export HOME="/home"

case "$MODE" in
  json-rpc|json-rpc-native)
    # Upstream stopt met een fatale fout als deze variabelen in json-rpc modus gezet zijn.
    # In json-rpc modus haalt signal-cli zelf continu berichten op.
    unset SIGNAL_CLI_CMD_TIMEOUT AUTO_RECEIVE_SCHEDULE
    ;;
  *)
    if [ -n "$CMD_TIMEOUT" ]; then export SIGNAL_CLI_CMD_TIMEOUT="$CMD_TIMEOUT"; fi
    if [ -n "$AUTO_RECEIVE_SCHEDULE" ]; then export AUTO_RECEIVE_SCHEDULE; fi
    ;;
esac

SIGNAL_UID=$(id -u signal-api)
SIGNAL_GID=$(id -g signal-api)

mkdir -p "$SIGNAL_CLI_CONFIG_DIR"
chown -R "${SIGNAL_UID}:${SIGNAL_GID}" "$SIGNAL_CLI_CONFIG_DIR"

echo "[signal-messenger] Starten in ${MODE} modus (auto_receive_schedule: ${AUTO_RECEIVE_SCHEDULE:-uit})"

# Start s6-overlay (upstream entrypoint) als signal-api, als PID 1.
exec setpriv --reuid="$SIGNAL_UID" --regid="$SIGNAL_GID" --init-groups /init
