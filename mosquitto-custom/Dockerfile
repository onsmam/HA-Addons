ARG BUILD_FROM=eclipse-mosquitto:2.0.21
FROM ${BUILD_FROM}

SHELL ["/bin/sh", "-o", "pipefail", "-c"]

RUN apk add --no-cache bash

COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
