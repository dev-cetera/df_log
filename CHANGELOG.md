# Changelog

## [0.6.0]

- Add `BootAudit` — a persistent boot-by-boot diagnostic trail that survives app restarts and lets you read events from earlier runs in devtools.
- Add `BootAuditStorage` interface, with bundled `InMemoryBootAuditStorage` (default, tests/non-web) and `LocalStorageBootAuditStorage` (browser `localStorage` on web; no-op stub elsewhere, selected at compile time via `dart.library.js_interop`).
- Add `web: ^1.1.0` dependency for the localStorage backend (only resolved on web builds).

## [0.5.0]

- Bump `df_safer_dart` constraint to `^0.21.0`.

## [0.5.0]

- Bump `df_safer_dart` constraint to `^0.20.0` (was `^0.17.8`); downstream pins on `^0.17.x` will need updating.

## [0.4.0]

- Released @ 5/2026 (UTC)
- Add Google analytics support