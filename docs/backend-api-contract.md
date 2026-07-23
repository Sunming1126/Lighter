# Lighter Backend API Contract (Draft v1)

This document is the server contract reserved by the local-first Flutter MVP. The app does not call these endpoints while `useMockRemote` is enabled.

## Transport and conventions

- Base path: `/v1`; JSON over HTTPS only.
- IDs are client-generated UUIDv7 strings. Timestamps are UTC ISO-8601 on the wire and UTC epoch milliseconds locally.
- Every mutable record includes `revision`, `updatedAt`, and optional `deletedAt`.
- Authenticated requests use `Authorization: Bearer <access-token>`.
- Mutating requests include `Idempotency-Key`; replays must return the original successful result.
- Error body: `{ "code": "stable_machine_code", "message": "safe user message", "requestId": "...", "details": {} }`.
- Collection pagination uses an opaque `cursor`; clients must not interpret it.

## Authentication

- `POST /v1/auth/register` — `{ email, password, displayName, deviceId }` → `{ user, accessToken, refreshToken, expiresAt }`.
- `POST /v1/auth/login` — `{ email, password, deviceId }` → same session response.
- `POST /v1/auth/refresh` — `{ refreshToken, deviceId }` → rotated token pair.
- `POST /v1/auth/logout` — revokes the current refresh token.
- `DELETE /v1/account` — starts irreversible account deletion and returns a deletion receipt.

Access tokens should be short-lived. Refresh tokens must be rotated, device-bound, hashed at rest, and revocable.

## Profile

- `GET /v1/profile` returns the authenticated profile and server revision.
- `PUT /v1/profile` accepts `{ displayName, locale, timezone, unitSystem, liquidUnit, baseRevision }`.
- A revision mismatch returns `409 revision_conflict` with the latest server record.

## Offline synchronization

### Push

`POST /v1/sync/push`

```json
{
  "deviceId": "uuid",
  "operations": [
    {
      "id": "operation-uuid",
      "idempotencyKey": "entity:id:operation:timestamp",
      "entityType": "fasting_session",
      "entityId": "entity-uuid",
      "operation": "upsert",
      "baseRevision": 2,
      "payload": {}
    }
  ]
}
```

The server returns one result per operation: `accepted`, `duplicate`, `conflict`, or `rejected`. Accepted writes return the authoritative revision and timestamp. The whole HTTP request may be retried, but each operation is independently idempotent.

### Pull

`GET /v1/sync/pull?cursor=<opaque>&limit=500`

```json
{
  "cursor": "next-opaque-cursor",
  "hasMore": false,
  "changes": [
    {
      "entityType": "weight_entry",
      "entityId": "uuid",
      "revision": 3,
      "updatedAt": "2026-07-22T10:20:30.000Z",
      "deletedAt": null,
      "payload": {}
    }
  ]
}
```

Sessions, water entries, and weight entries are append-oriented and use record-level optimistic concurrency. Plans and preferences use revision checks. Deletes are tombstones and must remain available to pull clients for the retention period.

## Canonical entity payloads

- `fasting_plan`: `id`, `fastMinutes`, `eatingMinutes`, `startMinuteOfDay`, `timezone`, `active`, `paused`, revision fields.
- `fasting_session`: `id`, `planId`, `startedAt`, `targetMinutes`, `endedAt`, `endReason`, `symptoms`, revision fields.
- `water_entry`: `id`, `sessionId`, `milliliters`, `loggedAt`, revision fields.
- `weight_entry`: `id`, `kilograms`, `loggedAt`, `note`, revision fields.
- `daily_health_log`: `id`, `dateKey`, `timezone`, `calories`, `steps`, revision fields. One active record per local calendar day.
- `reminder_settings`: reminder toggles, local wall-clock times, IANA timezone, revision fields.

Weight is always kilograms and water is always milliliters on the wire. Display units never alter stored values.

## Operational requirements

- PostgreSQL point-in-time recovery, encrypted backups, TLS, secret rotation, rate limiting, structured redacted logs, request tracing, health checks, and deployment rollback.
- Staging and production use separate databases, credentials, notification keys, and object storage.
- Health records and exports must never appear in application logs or analytics payloads.
- Account deletion must remove primary data and scheduled jobs, then age out encrypted backups according to the published retention policy.
