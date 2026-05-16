#!/bin/bash
set -e

SHARE_DIR="/share/nasdashboard"

mkdir -p "${SHARE_DIR}"

if [ ! -f "${SHARE_DIR}/index.html" ]; then
    echo "[nas-dashboard] Geen index.html gevonden in ${SHARE_DIR}, placeholder aanmaken..."
    cat > "${SHARE_DIR}/index.html" << 'EOF'
<!DOCTYPE html>
<html><head><meta charset="UTF-8"><title>NAS Dashboard</title></head>
<body style="font-family:sans-serif;padding:2rem">
<h2>NAS Dashboard</h2>
<p>Plaats je bestanden in <code>share/nasdashboard/</code> via Samba of SSH.</p>
</body></html>
EOF
fi

cat > /etc/nginx/conf.d/default.conf << EOF
server {
    listen 8081;
    root ${SHARE_DIR};
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

echo "[nas-dashboard] Starten op poort 8081, bestanden in ${SHARE_DIR}"
exec nginx -g "daemon off;"
