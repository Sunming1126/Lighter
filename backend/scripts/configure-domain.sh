#!/usr/bin/env bash
set -Eeuo pipefail

LIGHTER_DOMAIN="${LIGHTER_DOMAIN:-lighter.onesay.top}"
LIGHTER_EXPECTED_IP="${LIGHTER_EXPECTED_IP:-150.158.58.93}"
LIGHTER_UPSTREAM="${LIGHTER_UPSTREAM:-127.0.0.1:18080}"
LIGHTER_NGINX_AVAILABLE="/etc/nginx/sites-available/${LIGHTER_DOMAIN}"
LIGHTER_NGINX_ENABLED="/etc/nginx/sites-enabled/${LIGHTER_DOMAIN}"
LIGHTER_BACKUP_SUFFIX="$(date -u +%Y%m%dT%H%M%SZ)"

info() {
  printf '\033[0;32m[Lighter]\033[0m %s\n' "$*"
}

fail() {
  printf '\033[0;31m[Lighter] 配置失败：\033[0m%s\n' "$*" >&2
  exit 1
}

resolved_ip="$(getent ahostsv4 "${LIGHTER_DOMAIN}" | awk 'NR == 1 {print $1}')"
[[ "${resolved_ip}" == "${LIGHTER_EXPECTED_IP}" ]] \
  || fail "${LIGHTER_DOMAIN} 当前解析为 ${resolved_ip:-无结果}，预期为 ${LIGHTER_EXPECTED_IP}。"

curl --fail --silent --show-error "http://${LIGHTER_UPSTREAM}/health/ready" >/dev/null \
  || fail "Lighter API ${LIGHTER_UPSTREAM} 尚未就绪。"

command -v nginx >/dev/null 2>&1 || fail '服务器未安装 Nginx。'
command -v certbot >/dev/null 2>&1 || fail '服务器未安装 Certbot。'

sudo -v

if sudo test -e "${LIGHTER_NGINX_AVAILABLE}"; then
  sudo cp -a \
    "${LIGHTER_NGINX_AVAILABLE}" \
    "${LIGHTER_NGINX_AVAILABLE}.backup-${LIGHTER_BACKUP_SUFFIX}"
  info '已备份原有同名 Nginx 配置。'
fi

temporary_config="$(mktemp)"
trap 'rm -f "${temporary_config}"' EXIT
cat >"${temporary_config}" <<EOF
server {
    listen 80;
    listen [::]:80;
    server_name ${LIGHTER_DOMAIN};

    client_max_body_size 2m;

    location / {
        proxy_pass http://${LIGHTER_UPSTREAM};
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_connect_timeout 5s;
        proxy_read_timeout 30s;
        proxy_send_timeout 30s;
    }
}
EOF

sudo install -m 0644 -o root -g root "${temporary_config}" "${LIGHTER_NGINX_AVAILABLE}"
sudo ln -sfn "${LIGHTER_NGINX_AVAILABLE}" "${LIGHTER_NGINX_ENABLED}"
sudo nginx -t
sudo systemctl reload nginx

curl --fail --silent --show-error \
  -H "Host: ${LIGHTER_DOMAIN}" \
  http://127.0.0.1/health/ready >/dev/null \
  || fail 'Nginx HTTP 反向代理验证失败。'
info 'Nginx HTTP 反向代理验证通过。'

if ! certbot plugins 2>/dev/null | grep -q 'nginx'; then
  info '正在安装 Certbot Nginx 插件...'
  sudo apt-get update
  sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y python3-certbot-nginx
fi

if [[ -z "${LIGHTER_CERTBOT_EMAIL:-}" ]]; then
  printf '请输入用于证书到期提醒的邮箱：'
  read -r LIGHTER_CERTBOT_EMAIL
fi
[[ "${LIGHTER_CERTBOT_EMAIL}" == *@*.* ]] || fail '请输入有效邮箱地址。'

sudo certbot \
  --nginx \
  --domain "${LIGHTER_DOMAIN}" \
  --email "${LIGHTER_CERTBOT_EMAIL}" \
  --agree-tos \
  --no-eff-email \
  --redirect \
  --non-interactive

sudo nginx -t
sudo systemctl reload nginx
curl --fail --silent --show-error "https://${LIGHTER_DOMAIN}/health/ready"
printf '\n'
info "HTTPS 配置完成：https://${LIGHTER_DOMAIN}/v1"
