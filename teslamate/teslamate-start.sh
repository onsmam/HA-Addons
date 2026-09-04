#!/bin/sh
until pg_isready -h localhost -U teslamate 2>/dev/null; do
    echo "[teslamate] Wachten op PostgreSQL..."
    sleep 2
done
echo "[teslamate] PostgreSQL gereed, Teslamate starten..."
exec /app/bin/teslamate start
