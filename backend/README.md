# Lighter backend

This directory contains the deployable server foundation for the Lighter iOS app.
The current staging release intentionally exposes only health and API-version endpoints.
Authentication and synchronization remain disabled until their complete security and
data-ownership flows are implemented.

## Current endpoints

- `GET /health/live` — process liveness.
- `GET /health/ready` — process and PostgreSQL readiness.
- `GET /v1` — API version and enabled feature flags.

## Local checks

```sh
npm ci
npm run typecheck
npm test
npm run build
```

## Server deployment

Use `scripts/make-deploy-bundle.sh` on the Mac, upload the resulting archive,
then run `scripts/deploy-server.sh` on Ubuntu. See `服务器部署说明.md` for the
exact commands.

PostgreSQL is not published to the host. Port `8080` currently exposes only the
server foundation. Before the Flutter app connects, place the API behind a domain
with HTTPS and change its bind address to `127.0.0.1`.
