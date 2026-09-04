#!/bin/sh
until pg_isready -h localhost -U teslamate 2>/dev/null; do
    echo "[grafana] Wachten op PostgreSQL..."
    sleep 2
done
echo "[grafana] Starten..."
exec gosu 472 /usr/share/grafana/bin/grafana server \
    --homepath=/usr/share/grafana \
    --config=/etc/grafana/grafana.ini \
    --packaging=docker
