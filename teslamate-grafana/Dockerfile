FROM grafana/grafana:11.2.0

USER root
RUN apk add --no-cache jq curl

COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
