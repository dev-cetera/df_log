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

import 'dart:convert';

import 'boot_audit_storage.dart';
import 'log.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Persistent boot audit trail. Survives across app restarts (web reloads,
/// PWA cold starts, native process restarts when backed by appropriate
/// storage). The only thing that clears it is an explicit [clear] call.
///
/// Why this exists: in-memory logs from a prior run are gone by the time you
/// open devtools on the next run. Bugs that only reproduce on the second or
/// third launch leave no breadcrumbs in [Log.items] because the queue was
/// reset. [BootAudit] is the cross-boot companion to that in-memory queue:
/// a small, append-only stream of named events that you can read back from
/// any later boot.
///
/// ## Usage
///
/// Create one [BootAudit] near the start of `main()` and call [bootInit]
/// before any other work. Then log named events from anywhere:
///
/// ```dart
/// final audit = BootAudit(
///   appKey: 'myapp',
///   storage: LocalStorageBootAuditStorage(), // web; or InMemoryBootAuditStorage()
/// );
///
/// void main() {
///   audit.bootInit();
///   audit.log('CACHE_INIT', {'sizeBytes': cacheBytes});
///   runApp(const MyApp());
/// }
/// ```
///
/// ## Reading the trail
///
/// In-process: [readAll] returns every entry across every boot.
///
/// From the browser console (web backend):
///
/// ```js
/// JSON.parse(localStorage.getItem('<appKey>_boot_audit_v1'))
///     .forEach(e => console.log(e.b, e.e, e.t, e.d || ''));
/// ```
///
/// ## Bounded size
///
/// The trail is capped at [maxEntries] (oldest dropped first) so a chatty
/// app can't grow the storage payload without bound.
final class BootAudit {
  /// Detail-map key for the ISO-8601 timestamp of an entry.
  static const kTimestampKey = 't';

  /// Detail-map key for the boot number an entry belongs to.
  static const kBootNumberKey = 'b';

  /// Detail-map key for the event name.
  static const kEventKey = 'e';

  /// Detail-map key for the optional details map.
  static const kDetailsKey = 'd';

  //
  //
  //

  /// Prefix for the storage keys this instance reads and writes. Pick a
  /// short, app-specific token (e.g. `'myapp'`) so two apps sharing the
  /// same backend don't collide.
  final String appKey;

  /// Backend used to persist the trail. Stays small — JSON-encoded entries
  /// in a single key. See [BootAuditStorage] for bundled implementations.
  final BootAuditStorage storage;

  /// Hard cap on the number of entries kept on disk. Newer entries win:
  /// when the cap is exceeded the oldest entries are dropped on the next
  /// [log] call.
  final int maxEntries;

  //
  //
  //

  final String _auditKey;
  final String _counterKey;

  int _bootNumber = 0;
  final List<Map<String, dynamic>> _cache;

  //
  //
  //

  BootAudit({
    required this.appKey,
    required this.storage,
    this.maxEntries = 400,
  })  : _auditKey = '${appKey}_boot_audit_v1',
        _counterKey = '${appKey}_boot_counter_v1',
        _cache = _readRaw(storage, '${appKey}_boot_audit_v1');

  //
  //
  //

  /// Monotonically-increasing counter incremented once per [bootInit] call.
  /// `0` until [bootInit] runs.
  int get bootNumber => _bootNumber;

  //
  //
  //

  /// Call once at the very start of `main()`. Reads the prior trail, mirrors
  /// it to [Log] with a banner, increments the boot counter, then writes a
  /// fresh `BOOT_START` event with [bootDetails].
  ///
  /// Swallows its own errors and reports them through [Log.err] so a broken
  /// audit trail can never break startup.
  void bootInit({Map<String, dynamic>? bootDetails}) {
    try {
      _bootNumber = _readBootCounter() + 1;
      _writeBootCounter(_bootNumber);

      Log.info('boot #$_bootNumber — prior entries: ${_cache.length}');
      for (final entry in _cache) {
        Log.info(_formatEntry(entry));
      }

      log('BOOT_START', bootDetails);
    } catch (e) {
      Log.err('BootAudit.bootInit failed: $e');
    }
  }

  //
  //
  //

  /// Append an [event] to the trail (also mirrored to [Log.info] for live
  /// tails). [details] is an optional map of arbitrary JSON-encodable values.
  ///
  /// Each call flushes the trail to [storage] so a crash or tab close
  /// mid-boot doesn't lose events.
  void log(String event, [Map<String, dynamic>? details]) {
    try {
      final entry = <String, dynamic>{
        kTimestampKey: DateTime.now().toIso8601String(),
        kBootNumberKey: _bootNumber,
        kEventKey: event,
        if (details != null && details.isNotEmpty) kDetailsKey: details,
      };
      _cache.add(entry);
      while (_cache.length > maxEntries) {
        _cache.removeAt(0);
      }
      storage.write(_auditKey, jsonEncode(_cache));
      Log.info('#$_bootNumber ${_formatEntry(entry)}');
    } catch (e) {
      Log.err('BootAudit.log failed: $e (event=$event)');
    }
  }

  //
  //
  //

  /// Read every entry on the trail, across every boot, oldest first.
  /// Returns an unmodifiable view of the in-memory cache.
  List<Map<String, dynamic>> readAll() => List.unmodifiable(_cache);

  //
  //
  //

  /// Wipe the trail and reset the boot counter. Don't call this automatically
  /// — the whole point of the trail is that it survives. Reserve [clear] for
  /// an explicit debug button or test setup.
  void clear() {
    try {
      storage.remove(_auditKey);
      storage.remove(_counterKey);
      _bootNumber = 0;
      _cache.clear();
    } catch (_) {}
  }

  //
  //
  //

  static List<Map<String, dynamic>> _readRaw(
    BootAuditStorage storage,
    String key,
  ) {
    final raw = storage.read(key);
    if (raw == null || raw.isEmpty) {
      return <Map<String, dynamic>>[];
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        return <Map<String, dynamic>>[];
      }
      return decoded
          .whereType<Map<dynamic, dynamic>>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    } catch (_) {
      return <Map<String, dynamic>>[];
    }
  }

  //
  //
  //

  int _readBootCounter() {
    final raw = storage.read(_counterKey);
    if (raw == null) return 0;
    return int.tryParse(raw) ?? 0;
  }

  //
  //
  //

  void _writeBootCounter(int n) {
    storage.write(_counterKey, n.toString());
  }

  //
  //
  //

  String _formatEntry(Map<String, dynamic> entry) {
    final t = entry[kTimestampKey] ?? '';
    final b = entry[kBootNumberKey] ?? '?';
    final e = entry[kEventKey] ?? '?';
    final d = entry[kDetailsKey];
    if (d is Map) {
      return '$t b=$b $e ${jsonEncode(d)}';
    }
    return '$t b=$b $e';
  }
}
