import 'dart:convert' show jsonDecode;
import 'dart:isolate';

import 'package:df_log/df_log.dart';
import 'package:test/test.dart';

void main() {
  // Reset state before each test.
  setUp(() {
    Log.context = null;
    Log.enableStyling = false;
    Log.showIds = false;
    Log.showTags = true;
    Log.showTimestamps = false;
    Log.storeLogs = true;
    Log.maxStoredLogs = 500;
    Log.enableReleaseAsserts = false;
    Log.items.clear();
    Log.callbacks.clear();
    Log.onLogDiscarded = null;
    Log.useStandardPrint();
  });

  // ---------------------------------------------------------------------------
  // Basic logging
  // ---------------------------------------------------------------------------

  group('Basic logging', () {
    test('Log.info stores a log item', () {
      Log.info('hello');
      expect(Log.items.length, 1);
      expect(Log.items.last.message.toString(), 'hello');
    });

    test('All category methods store logs', () {
      Log.trace('trace');
      Log.err('err');
      Log.alert('alert');
      Log.ignore('ignore');
      Log.ok('ok');
      Log.start('start');
      Log.stop('stop');
      Log.info('info');
      Log.message('message');
      expect(Log.items.length, 9);
    });

    test('All colored print methods store logs', () {
      Log.printBlack('a');
      Log.printRed('b');
      Log.printGreen('c');
      Log.printYellow('d');
      Log.printBlue('e');
      Log.printPurple('f');
      Log.printCyan('g');
      Log.printWhite('h');
      Log.printLightBlack('i');
      Log.printLightRed('j');
      Log.printLightGreen('k');
      Log.printLightYellow('l');
      Log.printLightBlue('m');
      Log.printLightPurple('n');
      Log.printLightCyan('o');
      Log.printLightWhite('p');
      expect(Log.items.length, 16);
    });

    test('Log with null message', () {
      Log.info(null);
      expect(Log.items.length, 1);
      expect(Log.items.last.message, isNull);
    });

    test('Log with empty string message', () {
      Log.info('');
      expect(Log.items.length, 1);
      expect(Log.items.last.message.toString(), '');
    });

    test('Log with non-string message (int)', () {
      Log.info(42);
      expect(Log.items.last.message, 42);
      expect(Log.items.last.toConsoleString(), contains('42'));
    });

    test('Log with non-string message (list)', () {
      Log.info([1, 2, 3]);
      expect(Log.items.last.message.toString(), '[1, 2, 3]');
    });

    test('Log methods return _LogMessage with toString', () {
      final result = Log.info('test');
      expect(result.toString(), contains('test'));
    });
  });

  // ---------------------------------------------------------------------------
  // Category icons and tags
  // ---------------------------------------------------------------------------

  group('Category icons and tags', () {
    test('Log.trace produces correct icon and tag', () {
      Log.trace('t');
      final item = Log.items.last;
      expect(item.icon, contains('⚪'));
      expect(item.tags, contains(#trace));
    });

    test('Log.err produces correct icon and tag', () {
      Log.err('e');
      final item = Log.items.last;
      expect(item.icon, '🔴');
      expect(item.tags, contains(#err));
    });

    test('Log.alert produces correct icon and tag', () {
      Log.alert('a');
      final item = Log.items.last;
      expect(item.icon, '🟠');
      expect(item.tags, contains(#alert));
    });

    test('Log.ignore produces correct icon and tag', () {
      Log.ignore('i');
      final item = Log.items.last;
      expect(item.icon, '🟡');
      expect(item.tags, contains(#ignore));
    });

    test('Log.ok produces correct icon and tag', () {
      Log.ok('o');
      final item = Log.items.last;
      expect(item.icon, '🟢');
      expect(item.tags, contains(#ok));
    });

    test('Log.start produces correct icon and tag', () {
      Log.start('s');
      final item = Log.items.last;
      expect(item.icon, '🔵');
      expect(item.tags, contains(#start));
    });

    test('Log.stop produces correct icon and tag', () {
      Log.stop('s');
      final item = Log.items.last;
      expect(item.icon, '⚫');
      expect(item.tags, contains(#stop));
    });

    test('Log.info produces correct icon and tag', () {
      Log.info('i');
      final item = Log.items.last;
      expect(item.icon, '🟣');
      expect(item.tags, contains(#info));
    });

    test('Log.message produces correct icon and tag', () {
      Log.message('m');
      final item = Log.items.last;
      expect(item.icon, '🟤');
      expect(item.tags, contains(#message));
    });

    test('User tags are combined with category tag', () {
      Log.info('combined', {#auth, #network});
      final item = Log.items.last;
      expect(item.tags, contains(#info));
      expect(item.tags, contains(#auth));
      expect(item.tags, contains(#network));
    });

    test('Colored print methods have no icon', () {
      Log.printRed('red');
      final item = Log.items.last;
      expect(item.icon, isNull);
    });

    test('Colored print methods have no location brackets', () {
      Log.printRed('red');
      final output = Log.items.last.toConsoleString();
      // Should not have brackets since includePath is false.
      expect(output, isNot(contains('[')));
      expect(output, isNot(contains(']')));
    });

    test('Colored print methods have empty tags', () {
      Log.printRed('red');
      expect(Log.items.last.tags, isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  // Context (isolate labeling)
  // ---------------------------------------------------------------------------

  group('Log.context', () {
    test('context is null by default', () {
      expect(Log.context, isNull);
    });

    test('context can be set', () {
      Log.context = 'MAIN';
      expect(Log.context, 'MAIN');
    });

    test('context appears in console string', () {
      Log.context = 'MAIN';
      Log.info('hello');
      final output = Log.items.last.toConsoleString();
      expect(output, contains('MAIN'));
    });

    test('context appears in toMap', () {
      Log.context = 'OVERLAY';
      Log.info('hello');
      final map = Log.items.last.toMap();
      expect(map['context'], 'OVERLAY');
    });

    test('context appears in toJson', () {
      Log.context = 'OVERLAY';
      Log.info('hello');
      final json = Log.items.last.toJson();
      expect(json, contains('OVERLAY'));
    });

    test('context is null in toMap when not set', () {
      Log.info('hello');
      final map = Log.items.last.toMap();
      expect(map['context'], isNull);
    });

    test('context does NOT appear in console string when null', () {
      Log.info('hello');
      final output = Log.items.last.toConsoleString();
      // Should not have extra spaces from empty context.
      expect(output, isNot(contains('null')));
    });

    test('context does NOT appear when empty string', () {
      Log.context = '';
      Log.info('hello');
      final output = Log.items.last.toConsoleString();
      // Empty context should not add extra space.
      expect(output, isNot(contains('  ]')));
    });

    test('short context tag works', () {
      Log.context = 'M';
      Log.info('hello');
      final output = Log.items.last.toConsoleString();
      expect(output, contains('M'));
    });

    test('long context tag works', () {
      Log.context = 'ISOLATE_OVERLAY_SERVICE';
      Log.info('hello');
      final output = Log.items.last.toConsoleString();
      expect(output, contains('ISOLATE_OVERLAY_SERVICE'));
    });

    test('context is stored per LogItem', () {
      Log.context = 'A';
      Log.info('first');
      Log.context = 'B';
      Log.info('second');
      expect(Log.items.first.context, 'A');
      expect(Log.items.last.context, 'B');
    });
  });

  // ---------------------------------------------------------------------------
  // Isolate context isolation
  // ---------------------------------------------------------------------------

  group('Isolate context isolation', () {
    test('each isolate has its own Log.context', () async {
      Log.context = 'MAIN';

      final receivePort = ReceivePort();
      await Isolate.spawn(
        _isolateEntryPoint,
        receivePort.sendPort,
      );

      final result = await receivePort.first as String;

      // The spawned isolate should have its own context.
      expect(result, 'WORKER');
      // Main isolate context should be unchanged.
      expect(Log.context, 'MAIN');
    });

    test('isolate logs are independent', () async {
      Log.context = 'MAIN';
      Log.info('main log');

      final receivePort = ReceivePort();
      await Isolate.spawn(
        _isolateLogEntryPoint,
        receivePort.sendPort,
      );

      final result = await receivePort.first as Map;

      // Isolate should have stored its own logs independently.
      expect(result['context'], 'WORKER');
      expect(result['itemCount'], 1);
      // Main should still have only its own log.
      expect(Log.items.length, 1);
      expect(Log.items.last.context, 'MAIN');
    });
  });

  // ---------------------------------------------------------------------------
  // Callbacks
  // ---------------------------------------------------------------------------

  group('Callbacks', () {
    test('callback is called for each log', () {
      final captured = <LogItem>[];
      Log.addCallback((item) => captured.add(item));
      Log.info('a');
      Log.err('b');
      expect(captured.length, 2);
    });

    test('callback receives correct message', () {
      LogItem? captured;
      Log.addCallback((item) => captured = item);
      Log.info('test message');
      expect(captured, isNotNull);
      expect(captured!.message.toString(), 'test message');
    });

    test('callback receives context', () {
      LogItem? captured;
      Log.addCallback((item) => captured = item);
      Log.context = 'CTX';
      Log.info('test');
      expect(captured!.context, 'CTX');
    });

    test('removeCallback stops further calls', () {
      var count = 0;
      final cb = Log.addCallback((_) => count++);
      Log.info('a');
      expect(count, 1);
      Log.removeCallback(cb);
      Log.info('b');
      expect(count, 1);
    });

    test('callback error is rethrown', () {
      Log.addCallback((_) => throw Exception('boom'));
      expect(() => Log.info('test'), throwsException);
    });

    test('multiple callbacks all fire', () {
      var a = 0, b = 0;
      Log.addCallback((_) => a++);
      Log.addCallback((_) => b++);
      Log.info('test');
      expect(a, 1);
      expect(b, 1);
    });
  });

  // ---------------------------------------------------------------------------
  // Tag filtering
  // ---------------------------------------------------------------------------

  group('Tag filtering', () {
    test('untagged log is always stored', () {
      Log.printRed('no tags');
      expect(Log.items.length, 1);
    });

    test('log with active tag is stored', () {
      Log.addTags({#custom});
      Log.info('has active tag', {#custom});
      expect(Log.items.length, 1);
    });

    test('addTags and removeTags work', () {
      Log.addTags({#custom});
      expect(Log.activeTags.contains(#custom), isTrue);
      Log.removeTags({#custom});
      expect(Log.activeTags.contains(#custom), isFalse);
    });

    test('default activeTags includes all categories', () {
      expect(Log.activeTags.contains(#trace), isTrue);
      expect(Log.activeTags.contains(#err), isTrue);
      expect(Log.activeTags.contains(#alert), isTrue);
      expect(Log.activeTags.contains(#ignore), isTrue);
      expect(Log.activeTags.contains(#ok), isTrue);
      expect(Log.activeTags.contains(#start), isTrue);
      expect(Log.activeTags.contains(#stop), isTrue);
      expect(Log.activeTags.contains(#info), isTrue);
      expect(Log.activeTags.contains(#message), isTrue);
      expect(Log.activeTags.contains(#debug), isTrue);
    });

    test('log is stored even when tag filter suppresses printing', () {
      // Remove all category tags so nothing prints.
      Log.removeTags({#info});
      // But #info is the category tag, and the code checks ANY match.
      // Since the default still has #debug etc, let's make a stricter test.
      Log.activeTags = {}; // Empty = nothing active.
      Log.info('suppressed', {#custom});
      // Storage happens BEFORE tag filtering.
      expect(Log.items.length, 1);
      expect(Log.items.last.message.toString(), 'suppressed');
    });

    test('callbacks fire even when tag filter suppresses printing', () {
      Log.activeTags = {};
      LogItem? captured;
      Log.addCallback((item) => captured = item);
      Log.info('filtered', {#custom});
      expect(captured, isNotNull);
      expect(captured!.message.toString(), 'filtered');
    });
  });

  // ---------------------------------------------------------------------------
  // Log storage
  // ---------------------------------------------------------------------------

  group('Log storage', () {
    test('items queue respects maxStoredLogs', () {
      Log.maxStoredLogs = 3;
      for (var i = 0; i < 5; i++) {
        Log.info('log $i');
      }
      expect(Log.items.length, 3);
      // Oldest should be removed.
      expect(Log.items.first.message.toString(), 'log 2');
      expect(Log.items.last.message.toString(), 'log 4');
    });

    test('setting maxStoredLogs trims existing items', () {
      for (var i = 0; i < 10; i++) {
        Log.info('log $i');
      }
      expect(Log.items.length, 10);
      Log.maxStoredLogs = 3;
      expect(Log.items.length, 3);
    });

    test('maxStoredLogs cannot be negative', () {
      Log.maxStoredLogs = -5;
      expect(Log.maxStoredLogs, 0);
    });

    test('storeLogs = false prevents storage', () {
      Log.storeLogs = false;
      Log.info('not stored');
      expect(Log.items.length, 0);
    });

    test('internalIndex increments', () {
      Log.info('first');
      Log.info('second');
      final first = Log.items.first.internalIndex;
      final second = Log.items.last.internalIndex;
      expect(second, greaterThan(first));
    });

    test('maxStoredLogs = 0 prevents all storage', () {
      Log.maxStoredLogs = 0;
      Log.info('a');
      Log.info('b');
      expect(Log.items.length, 0);
    });

    test('storeLogs can be toggled mid-session', () {
      Log.info('stored');
      expect(Log.items.length, 1);
      Log.storeLogs = false;
      Log.info('not stored');
      expect(Log.items.length, 1);
      Log.storeLogs = true;
      Log.info('stored again');
      expect(Log.items.length, 2);
    });

    test('queue maintains FIFO order', () {
      for (var i = 0; i < 5; i++) {
        Log.info('msg $i');
      }
      final messages = Log.items.map((e) => e.message.toString()).toList();
      expect(messages, ['msg 0', 'msg 1', 'msg 2', 'msg 3', 'msg 4']);
    });

    test('setting maxStoredLogs trims from oldest', () {
      for (var i = 0; i < 5; i++) {
        Log.info('msg $i');
      }
      Log.maxStoredLogs = 2;
      final messages = Log.items.map((e) => e.message.toString()).toList();
      expect(messages, ['msg 3', 'msg 4']);
    });
  });

  // ---------------------------------------------------------------------------
  // Timestamps
  // ---------------------------------------------------------------------------

  group('Timestamps', () {
    test('timestamp not shown by default', () {
      Log.info('no time');
      final output = Log.items.last.toConsoleString();
      expect(output, isNot(contains('@')));
    });

    test('timestamp shown when enabled', () {
      Log.showTimestamps = true;
      Log.info('with time');
      final output = Log.items.last.toConsoleString();
      expect(output, contains('@'));
    });

    test('timestamp format is HH:mm:ss.SSS', () {
      Log.showTimestamps = true;
      Log.info('time format');
      final output = Log.items.last.toConsoleString();
      // Should match pattern like @12:34:56.789
      expect(output, matches(RegExp(r'@\d{2}:\d{2}:\d{2}\.\d{3}')));
    });

    test('timestamp in styled output', () {
      Log.showTimestamps = true;
      Log.info('styled time');
      final output = Log.items.last.toStyledConsoleString(
        messageStyle: AnsiStyle.fgRed,
        nonMessageStyle: AnsiStyle.fgLightBlack,
      );
      expect(output, contains('@'));
    });

    test('LogItem.timestamp is a valid DateTime', () {
      final before = DateTime.now();
      Log.info('ts');
      final after = DateTime.now();
      final ts = Log.items.last.timestamp;
      expect(ts.isAfter(before) || ts.isAtSameMomentAs(before), isTrue);
      expect(ts.isBefore(after) || ts.isAtSameMomentAs(after), isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  // IDs
  // ---------------------------------------------------------------------------

  group('IDs', () {
    test('ID not shown by default', () {
      Log.info('no id');
      final item = Log.items.last;
      final output = item.toConsoleString();
      expect(output, isNot(contains(item.id)));
    });

    test('ID shown when enabled', () {
      Log.showIds = true;
      Log.info('with id');
      final item = Log.items.last;
      final output = item.toConsoleString();
      expect(output, contains('<${item.id}>'));
    });

    test('each log has a unique ID', () {
      Log.info('a');
      Log.info('b');
      expect(Log.items.first.id, isNot(equals(Log.items.last.id)));
    });
  });

  // ---------------------------------------------------------------------------
  // toMap / toJson
  // ---------------------------------------------------------------------------

  group('toMap / toJson', () {
    test('toMap contains all expected keys', () {
      Log.context = 'TEST';
      Log.info('hello', {#custom});
      final map = Log.items.last.toMap();
      expect(map.containsKey('id'), isTrue);
      expect(map.containsKey('context'), isTrue);
      expect(map.containsKey('message'), isTrue);
      expect(map.containsKey('timestamp'), isTrue);
      expect(map.containsKey('tags'), isTrue);
      expect(map.containsKey('internalIndex'), isTrue);
      expect(map['context'], 'TEST');
      expect(map['message'], 'hello');
    });

    test('toJson produces valid JSON string', () {
      Log.info('json test');
      final json = Log.items.last.toJson();
      expect(json, isNotEmpty);
      expect(json, contains('"message"'));
      expect(json, contains('json test'));
    });

    test('toJson compact mode', () {
      Log.info('compact');
      final json = Log.items.last.toJson(pretty: false);
      // Compact should not have newlines.
      expect(json.contains('\n'), isFalse);
    });

    test('tags in toMap are unmangled', () {
      Log.info('tagged', {#myTag});
      final map = Log.items.last.toMap();
      final tags = map['tags'] as List;
      expect(tags, contains('myTag'));
      expect(tags, contains('info'));
    });

    test('toMap with no user tags still has category tag', () {
      Log.info('no user tags');
      final map = Log.items.last.toMap();
      final tags = map['tags'] as List;
      expect(tags, contains('info'));
    });

    test('toMap for colored print has null tags', () {
      Log.printRed('red');
      final map = Log.items.last.toMap();
      expect(map['tags'], isNull);
    });

    test('toMap for colored print has null icon', () {
      Log.printRed('red');
      final map = Log.items.last.toMap();
      expect(map['icon'], isNull);
    });

    test('toMap for colored print has null location', () {
      Log.printRed('red');
      final map = Log.items.last.toMap();
      expect(map['location'], isNull);
    });

    test('toMap contains all keys', () {
      Log.info('all keys');
      final map = Log.items.last.toMap();
      final expectedKeys = [
        'id',
        'column',
        'context',
        'icon',
        'internalIndex',
        'library',
        'line',
        'location',
        'message',
        'package',
        'tags',
        'timestamp',
        'uri',
      ];
      for (final key in expectedKeys) {
        expect(map.containsKey(key), isTrue, reason: 'Missing key: $key');
      }
    });

    test('toJson pretty has indentation', () {
      Log.info('pretty');
      final json = Log.items.last.toJson(pretty: true);
      expect(json, contains('  ')); // 2-space indentation.
    });

    test('timestamp in toMap is ISO8601', () {
      Log.info('iso');
      final map = Log.items.last.toMap();
      final ts = map['timestamp'] as String;
      // Should be parseable as DateTime.
      expect(() => DateTime.parse(ts), returnsNormally);
    });
  });

  // ---------------------------------------------------------------------------
  // Console string formatting
  // ---------------------------------------------------------------------------

  group('Console string formatting', () {
    test('toConsoleString includes icon and location', () {
      Log.info('hello');
      final output = Log.items.last.toConsoleString();
      expect(output, contains('['));
      expect(output, contains(']'));
      expect(output, contains('hello'));
    });

    test('toConsoleString includes tags when enabled', () {
      Log.showTags = true;
      Log.info('tagged', {#auth});
      final output = Log.items.last.toConsoleString();
      expect(output, contains('#auth'));
      expect(output, contains('#info'));
    });

    test('toConsoleString hides tags when disabled', () {
      Log.showTags = false;
      Log.info('tagged', {#auth});
      final output = Log.items.last.toConsoleString();
      expect(output, isNot(contains('#auth')));
    });

    test('toStyledConsoleString produces output', () {
      Log.info('styled');
      final output = Log.items.last.toStyledConsoleString(
        messageStyle: AnsiStyle.fgRed,
        nonMessageStyle: AnsiStyle.fgLightBlack,
      );
      expect(output, isNotEmpty);
      expect(output, contains('styled'));
    });

    test('toStyledConsoleString includes context', () {
      Log.context = 'STYLED_CTX';
      Log.info('styled');
      final output = Log.items.last.toStyledConsoleString(
        messageStyle: AnsiStyle.fgRed,
        nonMessageStyle: AnsiStyle.fgLightBlack,
      );
      expect(output, contains('STYLED_CTX'));
    });

    test('toString delegates to toConsoleString', () {
      Log.info('delegate');
      final item = Log.items.last;
      expect(item.toString(), item.toConsoleString());
    });

    test('styled output contains ANSI escape codes when styles provided', () {
      Log.info('ansi');
      final output = Log.items.last.toStyledConsoleString(
        messageStyle: AnsiStyle.fgRed,
        nonMessageStyle: AnsiStyle.fgLightBlack,
      );
      // ANSI escape codes start with \u001b[
      expect(output, contains('\u001b['));
    });

    test('styled output with null styles has no ANSI codes', () {
      Log.info('plain');
      final output = Log.items.last.toStyledConsoleString(
        messageStyle: null,
        nonMessageStyle: null,
      );
      expect(output, isNot(contains('\u001b[')));
    });

    test('styled output shows tags when enabled', () {
      Log.showTags = true;
      Log.info('tagged', {#custom});
      final output = Log.items.last.toStyledConsoleString(
        messageStyle: null,
        nonMessageStyle: AnsiStyle.fgLightBlack,
      );
      expect(output, contains('#custom'));
    });

    test('styled output shows ID when enabled', () {
      Log.showIds = true;
      Log.info('with id');
      final item = Log.items.last;
      final output = item.toStyledConsoleString(
        messageStyle: null,
        nonMessageStyle: null,
      );
      expect(output, contains(item.id));
    });

    test('context not shown for colored prints (no location)', () {
      Log.context = 'SHOULD_NOT_SHOW';
      Log.printRed('red');
      final output = Log.items.last.toConsoleString();
      // No brackets = no context shown.
      expect(output, isNot(contains('SHOULD_NOT_SHOW')));
      expect(output, 'red');
    });

    test('enableStyling uses styled output when true', () {
      Log.enableStyling = true;
      Log.info('styled test');
      final item = Log.items.last;
      final styled = item.toStyledConsoleString(
        messageStyle: AnsiStyle.fgRed,
        nonMessageStyle: AnsiStyle.fgLightBlack,
      );
      final unstyled = item.toConsoleString();
      // Styled should be longer due to ANSI codes.
      expect(styled.length, greaterThan(unstyled.length));
    });
  });

  // ---------------------------------------------------------------------------
  // Output function
  // ---------------------------------------------------------------------------

  group('Output function', () {
    test('useStandardPrint does not throw', () {
      Log.useStandardPrint();
      Log.info('standard');
    });

    test('useDeveloperLog does not throw', () {
      Log.useDeveloperLog();
      Log.info('developer');
    });
  });

  // ---------------------------------------------------------------------------
  // Context combined with other features
  // ---------------------------------------------------------------------------

  group('Context combined with other features', () {
    test('context + timestamp + tags + id', () {
      Log.context = 'ALL';
      Log.showTimestamps = true;
      Log.showTags = true;
      Log.showIds = true;
      Log.info('everything', {#custom});
      final output = Log.items.last.toConsoleString();
      expect(output, contains('ALL'));
      expect(output, contains('@'));
      expect(output, contains('#custom'));
      expect(output, contains('<'));
    });

    test('context in callback payload', () {
      Map<String, dynamic>? capturedMap;
      Log.addCallback((item) => capturedMap = item.toMap());
      Log.context = 'CB';
      Log.info('callback test');
      expect(capturedMap!['context'], 'CB');
    });
  });

  // ---------------------------------------------------------------------------
  // onLogDiscarded
  // ---------------------------------------------------------------------------

  group('onLogDiscarded', () {
    test('fires when queue overflows', () {
      Log.maxStoredLogs = 2;
      final discarded = <LogItem>[];
      Log.onLogDiscarded = (item) => discarded.add(item);
      Log.info('a');
      Log.info('b');
      expect(discarded, isEmpty);
      Log.info('c'); // This should discard 'a'.
      expect(discarded.length, 1);
      expect(discarded.first.message.toString(), 'a');
    });

    test('fires when maxStoredLogs is reduced', () {
      for (var i = 0; i < 5; i++) {
        Log.info('log $i');
      }
      final discarded = <LogItem>[];
      Log.onLogDiscarded = (item) => discarded.add(item);
      Log.maxStoredLogs = 2;
      expect(discarded.length, 3);
      expect(discarded.first.message.toString(), 'log 0');
    });

    test('not called when null', () {
      Log.maxStoredLogs = 1;
      Log.onLogDiscarded = null;
      Log.info('a');
      Log.info('b'); // Should not throw.
      expect(Log.items.length, 1);
    });

    test('fires multiple times in rapid succession', () {
      Log.maxStoredLogs = 2;
      Log.info('a');
      Log.info('b');
      final discarded = <String>[];
      Log.onLogDiscarded = (item) => discarded.add(item.message.toString());
      Log.info('c'); // discards 'a'
      Log.info('d'); // discards 'b'
      Log.info('e'); // discards 'c'
      expect(discarded, ['a', 'b', 'c']);
    });

    test('discarded item has all original data', () {
      Log.maxStoredLogs = 1;
      Log.context = 'DISC';
      LogItem? discardedItem;
      Log.onLogDiscarded = (item) => discardedItem = item;
      Log.info('will be discarded', {#custom});
      Log.info('new one');
      expect(discardedItem, isNotNull);
      expect(discardedItem!.message.toString(), 'will be discarded');
      expect(discardedItem!.context, 'DISC');
      expect(discardedItem!.tags, contains(#custom));
    });
  });

  // ---------------------------------------------------------------------------
  // Log.clear()
  // ---------------------------------------------------------------------------

  group('Log.clear()', () {
    test('clears all stored logs', () {
      Log.info('a');
      Log.info('b');
      expect(Log.items.length, 2);
      Log.clear();
      expect(Log.items.length, 0);
    });

    test('clear on empty queue is safe', () {
      Log.clear();
      expect(Log.items.length, 0);
    });

    test('can log again after clear', () {
      Log.info('before');
      Log.clear();
      Log.info('after');
      expect(Log.items.length, 1);
      expect(Log.items.last.message.toString(), 'after');
    });

    test('clear does not affect config', () {
      Log.context = 'CTX';
      Log.showTimestamps = true;
      Log.clear();
      expect(Log.context, 'CTX');
      expect(Log.showTimestamps, isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  // exportLogsToFile
  // ---------------------------------------------------------------------------

  group('exportLogsAsJsonLines', () {
    test('exports logs as JSONL string', () {
      Log.context = 'EXPORT_TEST';
      Log.info('export test 1');
      Log.err('export test 2');

      final jsonl = Log.exportLogsAsJsonLines();
      expect(jsonl, contains('export test 1'));
      expect(jsonl, contains('export test 2'));
      expect(jsonl, contains('EXPORT_TEST'));
      // JSONL = one JSON object per line.
      final lines = jsonl.trim().split('\n');
      expect(lines.length, 2);
    });

    test('each line is valid JSON', () {
      Log.info('line 1');
      Log.err('line 2');
      Log.ok('line 3');
      final jsonl = Log.exportLogsAsJsonLines();
      final lines = jsonl.trim().split('\n');
      for (final line in lines) {
        expect(() => jsonDecode(line), returnsNormally, reason: 'Invalid JSON: $line');
      }
    });

    test('export order matches queue order', () {
      Log.info('first');
      Log.info('second');
      Log.info('third');
      final jsonl = Log.exportLogsAsJsonLines();
      final lines = jsonl.trim().split('\n');
      final messages = lines.map((l) {
        final map = jsonDecode(l) as Map<String, dynamic>;
        return map['message'] as String;
      }).toList();
      expect(messages, ['first', 'second', 'third']);
    });

    test('exports empty queue as empty string', () {
      final jsonl = Log.exportLogsAsJsonLines();
      expect(jsonl.trim(), isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  // Auto isolate context detection
  // ---------------------------------------------------------------------------

  group('Context without auto-detection', () {
    test('no context by default', () {
      Log.info('from main');
      expect(Log.items.last.context, isNull);
    });

    test('manual context works', () {
      Log.context = 'MANUAL';
      Log.info('manual');
      expect(Log.items.last.context, 'MANUAL');
    });

    test('context can be cleared', () {
      Log.context = 'TEMP';
      Log.info('a');
      Log.context = null;
      Log.info('b');
      expect(Log.items.first.context, 'TEMP');
      expect(Log.items.last.context, isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // Flutter in-app friendly
  // ---------------------------------------------------------------------------

  group('In-app log display friendly', () {
    test('items queue is iterable for UI rendering', () {
      Log.info('a');
      Log.info('b');
      Log.info('c');
      final messages = Log.items.map((e) => e.message.toString()).toList();
      expect(messages, ['a', 'b', 'c']);
    });

    test('LogItem has all fields for UI display', () {
      Log.context = 'APP';
      Log.showTimestamps = true;
      Log.info('ui test', {#network});
      final item = Log.items.last;
      // All these should be accessible for building UI widgets.
      expect(item.id, isNotEmpty);
      expect(item.timestamp, isA<DateTime>());
      expect(item.message.toString(), 'ui test');
      expect(item.context, 'APP');
      expect(item.tags, isNotEmpty);
      expect(item.icon, isNotNull);
      expect(item.internalIndex, isNonNegative);
    });

    test('toMap provides complete data for serialization', () {
      Log.info('serialize me');
      final map = Log.items.last.toMap();
      expect(map, isA<Map<String, dynamic>>());
      expect(map['id'], isNotNull);
      expect(map['timestamp'], isNotNull);
      expect(map['message'], 'serialize me');
    });
  });
}

// ---------------------------------------------------------------------------
// Isolate entry points (must be top-level functions)
// ---------------------------------------------------------------------------

void _isolateEntryPoint(SendPort sendPort) {
  Log.context = 'WORKER';
  sendPort.send(Log.context);
}

void _isolateLogEntryPoint(SendPort sendPort) {
  Log.context = 'WORKER';
  Log.info('worker log');
  sendPort.send({
    'context': Log.context,
    'itemCount': Log.items.length,
  });
}

