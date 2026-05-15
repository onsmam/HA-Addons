# Mosquitto Custom Config Addon

Home Assistant addon that runs the official [Eclipse Mosquitto](https://mosquitto.org/) MQTT broker, letting you supply your own `mosquitto.conf`.

## Features

- Uses the official `eclipse-mosquitto` Docker image
- Reads your config from `/config/mosquitto/mosquitto.conf` (configurable)
- Falls back to a working default config if none is found
- Exposes ports 1883 (MQTT), 8883 (TLS), 9001 (WebSockets)

## Installation

Add this repository to Home Assistant and install the **Mosquitto Custom Config** addon.

See [DOCS.md](DOCS.md) for configuration details.
