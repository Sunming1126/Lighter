#!/usr/bin/env bash
set -Eeuo pipefail

LIGHTER_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIGHTER_SOURCE_DIR="$(cd "${LIGHTER_SCRIPT_DIR}/.." && pwd)"
LIGHTER_INSTALL_ROOT="${LIGHTER_INSTALL_ROOT:-/opt/lighter}"
LIGHTER_RELEASES_DIR="${LIGHTER_INSTALL_ROOT}/releases"
LIGHTER_SHARED_DIR="${LIGHTER_INSTALL_ROOT}/shared"
LIGHTER_CURRENT_LINK="${LIGHTER_INSTALL_ROOT}/current"
LIGHTER_ENV_FILE="${LIGHTER_SHARED_DIR}/.env"
LIGHTER_RELEASE_ID="$(date -u +%Y%m%dT%H%M%SZ)"
LIGHTER_RELEASE_DIR="${LIGHTER_RELEASES_DIR}/${LIGHTER_RELEASE_ID}"
LIGHTER_DEFAULT_PORT="${LIGHTER_PORT:-8080}"
LIGHTER_PROJECT_NAME="lighter"

LIGHTER_COLOR_GREEN='\033[0;32m'
LIGHTER_COLOR_YELLOW='\033[0;33m'
LIGHTER_COLOR_RED='\033[0;31m'
LIGHTER_COLOR_RESET='\033[0m'

info() {
  printf "${LIGHTER_COLOR_GREEN}[Lighter]${LIGHTER_COLOR_RESET} %s\n" "$*"
}

warn() {
  printf "${LIGHTER_COLOR_YELLOW}[Lighter]${LIGHTER_COLOR_RESET} %s\n" "$*" >&2
}

fail() {
  printf "${LIGHTER_COLOR_RED}[Lighter] 部署失败：${LIGHTER_COLOR_RESET}%s\n" "$*" >&2
  exit 1
}

require_source_file() {
  [[ -f "${LIGHTER_SOURCE_DIR}/$1" ]] || fail "部署包缺少 $1，请重新生成并上传完整压缩包。"
}

confirm_install() {
  if [[ "${LIGHTER_ASSUME_YES:-0}" == '1' ]]; then
    return
  fi
  printf '脚本可能安装 Docker，并会在 %s 创建 Lighter 服务。继续吗？[y/N] ' "${LIGHTER_INSTALL_ROOT}"
  read -r LIGHTER_CONFIRMATION
  [[ "${LIGHTER_CONFIRMATION}" =~ ^[Yy]$ ]] || fail '用户取消部署。'
}

install_docker_if_needed() {
  if command -v docker >/dev/null 2>&1 && sudo docker version >/dev/null 2>&1; then
    info 'Docker 已安装。'
  else
    info '正在安装 Docker...'
    sudo apt-get update
    sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates curl openssl docker.io
    sudo systemctl enable --now docker
  fi

  if sudo docker compose version >/dev/null 2>&1; then
    LIGHTER_COMPOSE_MODE='plugin'
    return
  fi

  info '正在安装 Docker Compose...'
  if sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y docker-compose-v2; then
    LIGHTER_COMPOSE_MODE='plugin'
  elif sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y docker-compose-plugin; then
    LIGHTER_COMPOSE_MODE='plugin'
  elif sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y docker-compose; then
    LIGHTER_COMPOSE_MODE='standalone'
  else
    fail 'Docker Compose 安装失败。'
  fi
}

compose() {
  if [[ "${LIGHTER_COMPOSE_MODE}" == 'plugin' ]]; then
    sudo docker compose "$@"
  else
    sudo docker-compose "$@"
  fi
}

env_value() {
  local key="$1"
  sudo awk -F= -v wanted="${key}" '$1 == wanted {sub(/^[^=]*=/, ""); print; exit}' "${LIGHTER_ENV_FILE}"
}

create_environment_if_needed() {
  sudo install -d -m 0755 "${LIGHTER_INSTALL_ROOT}" "${LIGHTER_RELEASES_DIR}"
  sudo install -d -m 0700 "${LIGHTER_SHARED_DIR}"

  if sudo test -f "${LIGHTER_ENV_FILE}"; then
    sudo sed -i "s/^APP_VERSION=.*/APP_VERSION=${LIGHTER_RELEASE_ID}/" "${LIGHTER_ENV_FILE}"
    info '沿用服务器上已有的数据库和部署配置。'
    return
  fi

  local password
  local temporary_env
  password="$(openssl rand -hex 32)"
  temporary_env="$(mktemp)"
  trap 'rm -f "${temporary_env:-}"' RETURN
  {
    printf 'NODE_ENV=staging\n'
    printf 'APP_VERSION=%s\n' "${LIGHTER_RELEASE_ID}"
    printf 'LOG_LEVEL=info\n'
    printf 'CORS_ORIGIN=\n'
    printf 'POSTGRES_DB=lighter_staging\n'
    printf 'POSTGRES_USER=lighter\n'
    printf 'POSTGRES_PASSWORD=%s\n' "${password}"
    printf 'LIGHTER_BIND_ADDRESS=%s\n' "${LIGHTER_BIND_ADDRESS:-0.0.0.0}"
    printf 'LIGHTER_PORT=%s\n' "${LIGHTER_DEFAULT_PORT}"
  } >"${temporary_env}"
  chmod 0600 "${temporary_env}"
  sudo install -m 0600 -o root -g root "${temporary_env}" "${LIGHTER_ENV_FILE}"
  rm -f "${temporary_env}"
  trap - RETURN
  info '已生成数据库随机密码和 staging 配置，配置文件仅 root 可读。'
}

check_port() {
  local port
  port="$(env_value LIGHTER_PORT)"
  [[ -n "${port}" ]] || port="${LIGHTER_DEFAULT_PORT}"

  if ! command -v ss >/dev/null 2>&1; then
    return
  fi
  if ! ss -ltnH "sport = :${port}" 2>/dev/null | grep -q LISTEN; then
    return
  fi
  if curl --silent --fail --max-time 3 "http://127.0.0.1:${port}/health/live" \
    | grep -q 'lighter-backend'; then
    info "检测到已有 Lighter 服务占用 ${port}，将执行平滑更新。"
    return
  fi
  fail "端口 ${port} 已被其他服务占用。请先确认占用者，或使用 LIGHTER_PORT=其他端口重新部署。"
}

copy_release() {
  info "正在创建发布版本 ${LIGHTER_RELEASE_ID}..."
  sudo install -d -m 0755 "${LIGHTER_RELEASE_DIR}"
  tar \
    --exclude='node_modules' \
    --exclude='dist' \
    --exclude='.env' \
    --exclude='coverage' \
    --exclude='.DS_Store' \
    -cf - \
    -C "${LIGHTER_SOURCE_DIR}" . \
    | sudo tar -xf - -C "${LIGHTER_RELEASE_DIR}"
  sudo ln -sfn "${LIGHTER_RELEASE_DIR}" "${LIGHTER_CURRENT_LINK}"
}

deploy_release() {
  info '正在构建并启动 API 与 PostgreSQL，首次执行可能需要几分钟...'
  compose \
    --project-name "${LIGHTER_PROJECT_NAME}" \
    --env-file "${LIGHTER_ENV_FILE}" \
    -f "${LIGHTER_RELEASE_DIR}/compose.server.yml" \
    up -d --build --remove-orphans
}

wait_until_ready() {
  local port
  local attempt
  port="$(env_value LIGHTER_PORT)"
  [[ -n "${port}" ]] || port="${LIGHTER_DEFAULT_PORT}"

  info '正在等待数据库迁移和服务健康检查...'
  for attempt in $(seq 1 60); do
    if curl --silent --fail --max-time 3 "http://127.0.0.1:${port}/health/ready" \
      | grep -q '"status":"ready"'; then
      info 'Lighter 后端已部署并通过健康检查。'
      printf '\n本机检查地址：\n'
      printf '  http://127.0.0.1:%s/health/live\n' "${port}"
      printf '  http://127.0.0.1:%s/health/ready\n' "${port}"
      printf '  http://127.0.0.1:%s/v1\n\n' "${port}"
      warn "若要从公网访问，请在腾讯云安全组放行 TCP ${port}。接入 iOS 前仍需配置域名和 HTTPS。"
      return
    fi
    sleep 2
  done

  compose \
    --project-name "${LIGHTER_PROJECT_NAME}" \
    --env-file "${LIGHTER_ENV_FILE}" \
    -f "${LIGHTER_RELEASE_DIR}/compose.server.yml" \
    ps || true
  compose \
    --project-name "${LIGHTER_PROJECT_NAME}" \
    --env-file "${LIGHTER_ENV_FILE}" \
    -f "${LIGHTER_RELEASE_DIR}/compose.server.yml" \
    logs --tail=120 api postgres || true
  fail '服务在 120 秒内没有就绪，以上是诊断日志。'
}

main() {
  [[ "$(uname -s)" == 'Linux' ]] || fail '此脚本只能在 Ubuntu/Linux 服务器执行。'
  command -v sudo >/dev/null 2>&1 || fail '服务器缺少 sudo。'
  command -v tar >/dev/null 2>&1 || fail '服务器缺少 tar。'
  require_source_file package.json
  require_source_file package-lock.json
  require_source_file Dockerfile
  require_source_file compose.server.yml
  require_source_file prisma/schema.prisma
  confirm_install
  sudo -v
  install_docker_if_needed
  create_environment_if_needed
  check_port
  copy_release
  deploy_release
  wait_until_ready
}

main "$@"
