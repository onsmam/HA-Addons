FROM johly/airtrail:v3.13.1

RUN apt-get update && apt-get install -y --no-install-recommends jq postgresql-client && rm -rf /var/lib/apt/lists/*

COPY run.sh /run.sh
COPY healthcheck.sh /healthcheck.sh
RUN chmod +x /run.sh /healthcheck.sh

# Standaard healthcheck van de image gebruikt altijd poort 3000
HEALTHCHECK --interval=5m --start-period=5m --start-interval=10s --retries=3 CMD ["/healthcheck.sh"]

ENTRYPOINT ["/run.sh"]
