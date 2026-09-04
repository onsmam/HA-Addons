FROM teslamate/teslamate:latest AS teslamate

FROM grafana/grafana:11.2.0 AS grafana

FROM postgres:17.5

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    jq \
    curl \
    supervisor \
    gosu \
    libpq5 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=teslamate /app /app
COPY --from=grafana /usr/share/grafana /usr/share/grafana
COPY --from=grafana /etc/grafana /etc/grafana
COPY --from=grafana /var/lib/grafana /var/lib/grafana

COPY supervisord.conf /etc/supervisor/conf.d/teslamate.conf
COPY run.sh /run.sh
COPY grafana-start.sh /grafana-start.sh
COPY teslamate-start.sh /teslamate-start.sh

RUN chmod +x /run.sh /grafana-start.sh /teslamate-start.sh

ENV PATH="/usr/share/grafana/bin:${PATH}"

CMD ["/run.sh"]
