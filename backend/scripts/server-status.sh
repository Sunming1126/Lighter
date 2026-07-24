#!/usr/bin/env bash
set -Eeuo pipefail

LIGHTER_INSTALL_ROOT="${LIGHTER_INSTALL_ROOT:-/opt/lighter}"
LIGHTER_CURRENT_DIR="${LIGHTER_INSTALL_ROOT}/current"
LIGHTER_ENV_FILE="${LIGHTER_INSTALL_ROOT}/shared/.env"

if sudo docker compose version >/dev/null 2>&1; then
  LIGHTER_COMPOSE=(sudo docker compose)
else
  LIGHTER_COMPOSE=(sudo docker-compose)
fi

sudo test -f "${LIGHTER_ENV_FILE}" || {
  echo '尚未找到 Lighter 服务器配置。' >&2
  exit 1
}

"${LIGHTER_COMPOSE[@]}" \
  --project-name lighter \
  --env-file "${LIGHTER_ENV_FILE}" \
  -f "${LIGHTER_CURRENT_DIR}/compose.server.yml" \
  ps

LIGHTER_PORT_VALUE="$(sudo awk -F= '$1 == "LIGHTER_PORT" {print $2; exit}' "${LIGHTER_ENV_FILE}")"
LIGHTER_PORT_VALUE="${LIGHTER_PORT_VALUE:-8080}"
curl --fail --silent --show-error "http://127.0.0.1:${LIGHTER_PORT_VALUE}/health/ready"
printf '\n'
