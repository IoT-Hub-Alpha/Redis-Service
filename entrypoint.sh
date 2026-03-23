#!/bin/bash
set -euo pipefail

: "${REDIS_PORT:=6379}"
: "${REDIS_PASSWORD:=""}"
: "${REDIS_MAXMEMORY:=512mb}"
: "${REDIS_DATA_DIR:=/var/lib/redis}"

CONFIG_FILE="/etc/redis/redis.conf"

echo "Configuring Redis..."

cat > "${CONFIG_FILE}" <<EOF
bind 0.0.0.0
port ${REDIS_PORT}
dir ${REDIS_DATA_DIR}
maxmemory ${REDIS_MAXMEMORY}
maxmemory-policy allkeys-lru
appendonly yes
protected-mode no
tcp-keepalive 60
EOF

if [ -n "${REDIS_PASSWORD}" ]; then
    echo "requirepass ${REDIS_PASSWORD}" >> "${CONFIG_FILE}"
fi

mkdir -p "${REDIS_DATA_DIR}"
chown -R redis:redis "${REDIS_DATA_DIR}"

echo "Starting Redis on port ${REDIS_PORT}..."

exec gosu redis redis-server "${CONFIG_FILE}"
