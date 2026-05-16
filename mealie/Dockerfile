FROM ghcr.io/mealie-recipes/mealie:v3.17.0

RUN apt-get update && apt-get install -y --no-install-recommends jq && rm -rf /var/lib/apt/lists/*

COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
