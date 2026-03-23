FROM debian:bookworm-slim

ENV REDIS_DATA_DIR=/var/lib/redis

RUN apt-get update && apt-get install -y --no-install-recommends \
    redis-server \
    gosu \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/redis ${REDIS_DATA_DIR}
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD redis-cli ping || exit 1

VOLUME ["${REDIS_DATA_DIR}"]
EXPOSE 6379

ENTRYPOINT ["entrypoint.sh"]
