#!/usr/bin/env bash
set -Eeuo pipefail

LIGHTER_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIGHTER_BACKEND_DIR="$(cd "${LIGHTER_SCRIPT_DIR}/.." && pwd)"
LIGHTER_PROJECT_DIR="$(cd "${LIGHTER_BACKEND_DIR}/.." && pwd)"
LIGHTER_BUILD_ID="$(date -u +%Y%m%dT%H%M%SZ)"
LIGHTER_BUNDLE_PATH="${LIGHTER_PROJECT_DIR}/lighter-backend-deploy-${LIGHTER_BUILD_ID}.tar.gz"

COPYFILE_DISABLE=1 tar \
  --exclude='node_modules' \
  --exclude='dist' \
  --exclude='.env' \
  --exclude='coverage' \
  --exclude='.DS_Store' \
  -czf "${LIGHTER_BUNDLE_PATH}" \
  -C "${LIGHTER_PROJECT_DIR}" \
  backend

printf 'Deployment bundle created:\n%s\n' "${LIGHTER_BUNDLE_PATH}"
