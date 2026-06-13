//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Copyright © dev-cetera.com & contributors.
//
// The use of this source code is governed by an MIT-style license described in
// the LICENSE file located in this project's root directory.
//
// See: https://opensource.org/license/mit
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Synchronous key/value backend used by [BootAudit] to persist its trail
/// across app boots.
///
/// Implementations must be synchronous so [BootAudit.log] can run from the
/// very first line of `main()` without awaiting a future. The contract is
/// deliberately minimal — JSON-encoded strings in, JSON-encoded strings out.
///
/// Bundled implementations:
///
/// - [InMemoryBootAuditStorage] — process-local, lost on restart. Useful for
///   tests and non-web platforms where persistence isn't wired yet.
/// - [LocalStorageBootAuditStorage] — browser `localStorage` on web, no-op on
///   non-web (selected at compile time via `dart.library.js_interop`).
///
/// To plug in a different backend (e.g. `SharedPreferences`, a file on
/// disk, IndexedDB), implement this interface and pass an instance to the
/// [BootAudit] constructor.
abstract interface class BootAuditStorage {
  /// Returns the value stored under [key], or `null` if absent or unreadable.
  ///
  /// Must never throw. A backend that can't read should swallow the failure
  /// and return `null`. The audit trail itself is a diagnostic — it cannot
  /// be allowed to break the host app.
  String? read(String key);

  /// Persists [value] under [key], overwriting any previous value.
  ///
  /// Must never throw. A backend that can't write should swallow the failure
  /// silently.
  void write(String key, String value);

  /// Removes any value stored under [key]. No-op if absent.
  ///
  /// Must never throw.
  void remove(String key);
}
