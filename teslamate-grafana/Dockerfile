FROM teslamate/grafana:latest

USER root
RUN apk add --no-cache jq

COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
