FROM bbernhard/signal-cli-rest-api:0.102

# Upstream draait vanaf 0.102 als 'signal-api'; root nodig voor apt en voor
# het goedzetten van de rechten op /config bij het starten (zie run.sh).
USER root
RUN apt-get update && apt-get install -y --no-install-recommends jq && rm -rf /var/lib/apt/lists/*

COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
