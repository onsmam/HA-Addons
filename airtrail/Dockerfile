FROM johly/airtrail:v3.13.1

RUN apt-get update && apt-get install -y --no-install-recommends jq postgresql-client && rm -rf /var/lib/apt/lists/*

COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
