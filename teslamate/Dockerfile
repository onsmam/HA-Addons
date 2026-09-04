FROM teslamate/teslamate:latest

USER root
RUN apt-get update && apt-get install -y --no-install-recommends jq && rm -rf /var/lib/apt/lists/*
RUN find / -name "teslamate" -type f 2>/dev/null && echo "---PATH CHECK---" && echo $PATH

COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
