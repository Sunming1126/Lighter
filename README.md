# Lighter

Lighter is a gentle, local-first intermittent fasting app for iPhone. The Flutter UI is rebuilt from the reference HTML files in this repository; the app does not embed a web view.

## Included in the local MVP

- Bilingual onboarding with safety screening and a 12:12 starter plan.
- Timestamp-based fasting timer that survives backgrounding and restarts.
- Daily water, weight, calories and steps, visual fasting calendar, 12 selectable plans, history, weekly/monthly statistics, local notifications, JSON/CSV export, and local deletion.
- Guest-first use and clearly labelled mock registration/sign-in.
- Drift/SQLite persistence with schema migrations, IANA timezone capture, record revisions, tombstones, and a transactional synchronization outbox.
- Versioned server contract in `docs/backend-api-contract.md`.

## Development

```sh
flutter pub get
flutter pub run build_runner build
flutter gen-l10n
flutter analyze
flutter test
flutter run
```

The iOS target is iPhone, portrait orientation, iOS 16 or newer. `AppConfig.current` supports `dev`, `staging`, and `production`; the default `dev` configuration keeps the remote data source disabled. No credentials or server access are required for the MVP.

## Release gates

Health and safety copy requires medical and legal review before App Store submission. Replace the development bundle identifier and configure signing before release.
