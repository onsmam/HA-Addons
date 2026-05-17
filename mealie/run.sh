#!/bin/sh
set -e

DATA_DIR=$(jq -r '.data_dir' /data/options.json)
BASE_URL=$(jq -r '.base_url' /data/options.json)
ALLOW_SIGNUP=$(jq -r '.allow_signup' /data/options.json)
VISIBLE_FOR_ALL=$(jq -r '.visible_for_all_users' /data/options.json)
DEFAULT_EMAIL=$(jq -r '.default_email' /data/options.json)
DEFAULT_PASSWORD=$(jq -r '.default_password' /data/options.json)
OIDC_AUTH_ENABLED=$(jq -r '.oidc_auth_enabled' /data/options.json)
OIDC_CONFIGURATION_URL=$(jq -r '.oidc_configuration_url' /data/options.json)
OIDC_CLIENT_ID=$(jq -r '.oidc_client_id' /data/options.json)
OIDC_CLIENT_SECRET=$(jq -r '.oidc_client_secret' /data/options.json)
OIDC_PROVIDER_NAME=$(jq -r '.oidc_provider_name' /data/options.json)
OIDC_SIGNUP_ENABLED=$(jq -r '.oidc_signup_enabled' /data/options.json)
OIDC_AUTO_REDIRECT=$(jq -r '.oidc_auto_redirect' /data/options.json)

mkdir -p "${DATA_DIR}"
chown -R 911:911 "${DATA_DIR}"

export DATA_DIR="${DATA_DIR}"
export ALLOW_SIGNUP="${ALLOW_SIGNUP}"
export DEFAULT_EMAIL="${DEFAULT_EMAIL}"
export DEFAULT_PASSWORD="${DEFAULT_PASSWORD}"
export DB_ENGINE="sqlite"
export WEB_CONCURRENCY="1"
export WORKERS_PER_CORE="0.5"

if [ -n "${BASE_URL}" ] && [ "${BASE_URL}" != "null" ] && [ "${BASE_URL}" != "" ]; then
    export BASE_URL="${BASE_URL}"
fi

export OIDC_AUTH_ENABLED="${OIDC_AUTH_ENABLED}"
if [ "${OIDC_AUTH_ENABLED}" = "true" ]; then
    echo "[mealie] OIDC ingeschakeld via ${OIDC_PROVIDER_NAME}"
    export OIDC_CONFIGURATION_URL="${OIDC_CONFIGURATION_URL}"
    export OIDC_CLIENT_ID="${OIDC_CLIENT_ID}"
    export OIDC_CLIENT_SECRET="${OIDC_CLIENT_SECRET}"
    export OIDC_PROVIDER_NAME="${OIDC_PROVIDER_NAME}"
    export OIDC_SIGNUP_ENABLED="${OIDC_SIGNUP_ENABLED}"
    export OIDC_AUTO_REDIRECT="${OIDC_AUTO_REDIRECT}"
fi

echo "[mealie] Starten met data in ${DATA_DIR}"
exec /app/run.sh
