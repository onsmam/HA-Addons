# Mosquitto Custom Config

Eclipse Mosquitto MQTT broker using the official Docker image. You provide your own configuration file.

## Setup

1. Create the folder `share/mosquitto/` via Samba or SSH.
2. Place your `mosquitto.conf` file in that folder.
3. Set `config_path` in the addon options to the path of your config file (default: `/share/mosquitto/mosquitto.conf`).
4. Start the addon.

If no config file is found at the specified path, a minimal default config is created automatically.
The addon also creates a `persistence/` subfolder next to the config for storing `mosquitto.db`.

```
share/
└── mosquitto/
    ├── mosquitto.conf
    └── persistence/
        └── mosquitto.db
```

## Example mosquitto.conf

```
listener 1883
allow_anonymous false

password_file /share/mosquitto/passwd

persistence true
persistence_location /share/mosquitto/persistence/

log_dest stdout
```

## TLS / Certificates

Place your certificates in `/share/mosquitto/certs/` and reference them in your config:

```
listener 8883
cafile /share/mosquitto/certs/ca.crt
certfile /share/mosquitto/certs/server.crt
keyfile /share/mosquitto/certs/server.key
```

## Ports

| Port | Protocol | Description |
|------|----------|-------------|
| 1883 | TCP | MQTT plaintext |
| 8883 | TCP | MQTT over TLS |
| 9001 | TCP | MQTT over WebSockets |

## Options

| Option | Default | Description |
|--------|---------|-------------|
| `config_path` | `/share/mosquitto/mosquitto.conf` | Path to your mosquitto.conf |
