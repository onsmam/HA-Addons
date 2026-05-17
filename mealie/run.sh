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

# Haal ingress pad op via supervisor API
INGRESS_ENTRY=$(curl -sf \
    -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" \
    "http://supervisor/addons/self/info" | jq -r '.data.ingress_entry // empty')

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

# Vertel de Nuxt frontend zijn base pad (voor ingress)
if [ -n "${INGRESS_ENTRY}" ]; then
    export NUXT_APP_BASE_URL="${INGRESS_ENTRY}/"
    export BASE_SUBPATH="${INGRESS_ENTRY}/"
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
echo "[mealie] Ingress pad: ${INGRESS_ENTRY:-geen}"

# Start Mealie op de achtergrond
/app/run.sh &

# Wacht tot Mealie bereikbaar is
echo "[mealie] Wachten op Mealie..."
until curl -sf http://localhost:9000/ > /dev/null 2>&1; do
    sleep 2
done
echo "[mealie] Mealie is gestart."

# Stel nginx in als ingress proxy met pad-herschrijving
if [ -n "${INGRESS_ENTRY}" ]; then
    cat > /etc/nginx/conf.d/ingress.conf << EOF
server {
    listen 8099;

    location ${INGRESS_ENTRY}/ {
        proxy_pass http://localhost:9000/;

        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$http_host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;

        absolute_redirect off;
        proxy_redirect / ${INGRESS_ENTRY}/;

        sub_filter_once off;
        sub_filter_types *;
        sub_filter '"/api' '"${INGRESS_ENTRY}/api';
        sub_filter '\`/api' '\`${INGRESS_ENTRY}/api';
        sub_filter 'href="/"' 'href="${INGRESS_ENTRY}/"';
        sub_filter 'action="/"' 'action="${INGRESS_ENTRY}/"';
    }
}
EOF
    echo "[mealie] Nginx ingress proxy starten op poort 8099"
    exec nginx -g "daemon off;"
else
    echo "[mealie] Geen ingress, Mealie direct bereikbaar op poort 9000"
    wait
fi
