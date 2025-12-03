//title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
// Dart/Flutter (DF) Packages by dev-cetera.com & contributors. The use of this
// source code is governed by an MIT-style license described in the LICENSE
// file located in this project's root directory.
//
// See: https://opensource.org/license/mit
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//title~

import 'dart:developer' as developer;

import '/_common.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

final class Log {
  //
  //
  //

  const Log._();

  //
  //
  //

  /// A filter for console output. A log is printed if untagged, or if ALL of
  /// its tags are present in this set.
  static var activeTags = {#debug, ..._IconCategory.values.map((e) => e.tag)};

  /// Adds [tags] to [activeTags].
  static void addTags(Set<Symbol> tags) {
    activeTags.addAll(tags);
  }

  /// Removes [tags] from [activeTags].
  static void removeTags(Set<Symbol> tags) {
    activeTags.removeAll(tags);
  }

  /// If `true`, new logs are added to the in-memory `items` queue.
  static var storeLogs = true;

  static int _maxStoredLogs = 500;

  /// The maximum number of logs to keep in memory. Older logs are discarded.
  static int get maxStoredLogs => _maxStoredLogs;

  /// Sets thhe maximum number of logs to keep in memory. Discards any older
  /// logs exceeding this limit.
  static set maxStoredLogs(int value) {
    _maxStoredLogs = value < 0 ? 0 : value;
    while (items.length > _maxStoredLogs) {
      items.removeFirst();
    }
  }

  /// An in-memory queue of the most recent log items, capped by `maxStoredLogs`.
  static final items = Queue<LogItem>();

  /// If `true`, enables colors and other ANSI styling in the console output.
  static var enableStyling = false;

  /// If `true`, `Log.assert()` will be evaluated and logs will be printed
  /// even in release builds.
  static var enableReleaseAsserts = false;

  /// If `true`, the logs will be printed with IDs.
  static var showIds = false;

  /// If `true`, the logs will be printed with tags.
  static var showTags = true;

  /// If `true`, the logs will be printed with timestamps.
  static var showTimestamps = false;

  /// A list of callbacks invoked whenever a new log is created.
  static final callbacks = <void Function(LogItem item)>[];

  /// Registers a function to be called for each new log item.
  /// Returns the callback to allow for later removal.
  static void Function(LogItem item) addCallback(
    void Function(LogItem logItem) callback,
  ) {
    callbacks.add(callback);
    return callback;
  }

  /// Unregisters a previously added callback from the `callbacks` list.
  static void removeCallback(void Function(LogItem item) callback) {
    callbacks.remove(callback);
  }

  /// Redirects output to `developer.log`, which is often richer in IDEs.
  static void useDeveloperLog() {
    _printFunction = (e) => developer.log(e.toString());
  }

  /// Resets the output function to the standard `print`.
  static void useStandardPrint() {
    _printFunction = print;
  }

  /// The internal function used for printing. Defaults to the standard `print`.
  static void Function(Object?) _printFunction = print;

  //
  //
  //

  @pragma('vm:prefer-inline')
  static _LogMessage trace(
    Object? message, [
    Set<Symbol> tags = const {},
    @visibleForTesting int initialStackLevel = 0,
  ]) {
    return log(
      message: message,
      category: _IconCategory.TRACE,
      tags: tags,
      nonMessageStyle: AnsiStyle.fgLightBlack,
      initialStackLevel: initialStackLevel,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage err(
    Object? message, [
    Set<Symbol> tags = const {},
    @visibleForTesting int initialStackLevel = 0,
  ]) {
    return log(
      message: message,
      category: _IconCategory.ERR,
      tags: tags,
      nonMessageStyle: AnsiStyle.fgLightBlack,
      initialStackLevel: initialStackLevel,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage alert(
    Object? message, [
    Set<Symbol> tags = const {},
    @visibleForTesting int initialStackLevel = 0,
  ]) {
    return log(
      message: message,
      category: _IconCategory.ALERT,
      tags: tags,
      nonMessageStyle: AnsiStyle.fgLightBlack,
      initialStackLevel: initialStackLevel,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage ignore(
    Object? message, [
    Set<Symbol> tags = const {},
    @visibleForTesting int initialStackLevel = 0,
  ]) {
    return log(
      message: message,
      category: _IconCategory.IGNORE,
      tags: tags,
      nonMessageStyle: AnsiStyle.fgLightBlack,
      messageStyle: AnsiStyle.strikethrough,
      initialStackLevel: initialStackLevel,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage ok(
    Object? message, [
    Set<Symbol> tags = const {},
    @visibleForTesting int initialStackLevel = 0,
  ]) {
    return log(
      message: message,
      category: _IconCategory.OK,
      tags: tags,
      nonMessageStyle: AnsiStyle.fgLightBlack,
      initialStackLevel: initialStackLevel,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage start(
    Object? message, [
    Set<Symbol> tags = const {},
    @visibleForTesting int initialStackLevel = 0,
  ]) {
    return log(
      message: message,
      category: _IconCategory.START,
      tags: tags,
      nonMessageStyle: AnsiStyle.fgLightBlack,
      initialStackLevel: initialStackLevel,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage stop(
    Object? message, [
    Set<Symbol> tags = const {},
    @visibleForTesting int initialStackLevel = 0,
  ]) {
    return log(
      message: message,
      category: _IconCategory.STOP,
      tags: tags,
      nonMessageStyle: AnsiStyle.fgLightBlack,
      initialStackLevel: initialStackLevel,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage info(
    Object? message, [
    Set<Symbol> tags = const {},
    @visibleForTesting int initialStackLevel = 0,
  ]) {
    return log(
      message: message,
      category: _IconCategory.INFO,
      tags: tags,
      nonMessageStyle: AnsiStyle.fgLightBlack,
      initialStackLevel: initialStackLevel,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage message(
    Object? message, [
    Set<Symbol> tags = const {},
    @visibleForTesting int initialStackLevel = 0,
  ]) {
    return log(
      message: message,
      category: _IconCategory.MESSAGE,
      tags: tags,
      nonMessageStyle: AnsiStyle.fgLightBlack,
      initialStackLevel: initialStackLevel,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage printBlack(
    Object? message, [
    @visibleForTesting int initialStackLevel = 0,
  ]) {
    return log(
      message: message,
      messageStyle: AnsiStyle.fgBlack,
      includePath: false,
      initialStackLevel: initialStackLevel,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage printRed(
    Object? message, [
    @visibleForTesting int initialStackLevel = 0,
  ]) {
    return log(
      message: message,
      messageStyle: AnsiStyle.fgRed,
      includePath: false,
      initialStackLevel: initialStackLevel,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage printGreen(
    Object? message, [
    @visibleForTesting int initialStackLevel = 0,
  ]) {
    return log(
      message: message,
      messageStyle: AnsiStyle.fgGreen,
      includePath: false,
      initialStackLevel: initialStackLevel,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage printYellow(
    Object? message, [
    @visibleForTesting int initialStackLevel = 0,
  ]) {
    return log(
      message: message,
      messageStyle: AnsiStyle.fgYellow,
      includePath: false,
      initialStackLevel: initialStackLevel,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage printBlue(
    Object? message, [
    @visibleForTesting int initialStackLevel = 0,
  ]) {
    return log(
      message: message,
      messageStyle: AnsiStyle.fgBlue,
      includePath: false,
      initialStackLevel: initialStackLevel,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage printPurple(
    Object? message, [
    @visibleForTesting int initialStackLevel = 0,
  ]) {
    return log(
      message: message,
      messageStyle: AnsiStyle.fgPurple,
      includePath: false,
      initialStackLevel: initialStackLevel,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage printCyan(
    Object? message, [
    @visibleForTesting int initialStackLevel = 0,
  ]) {
    return log(
      message: message,
      messageStyle: AnsiStyle.fgCyan,
      includePath: false,
      initialStackLevel: initialStackLevel,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage printWhite(
    Object? message, [
    @visibleForTesting int initialStackLevel = 0,
  ]) {
    return log(
      message: message,
      messageStyle: AnsiStyle.fgWhite,
      includePath: false,
      initialStackLevel: initialStackLevel,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage printLightBlack(
    Object? message, [
    @visibleForTesting int initialStackLevel = 0,
  ]) {
    return log(
      message: message,
      messageStyle: AnsiStyle.fgLightBlack,
      includePath: false,
      initialStackLevel: initialStackLevel,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage printLightRed(
    Object? message, [
    @visibleForTesting int initialStackLevel = 0,
  ]) {
    return log(
      message: message,
      messageStyle: AnsiStyle.fgRed,
      includePath: false,
      initialStackLevel: initialStackLevel,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage printLightGreen(
    Object? message, [
    @visibleForTesting int initialStackLevel = 0,
  ]) {
    return log(
      message: message,
      messageStyle: AnsiStyle.fgLightGreen,
      includePath: false,
      initialStackLevel: initialStackLevel,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage printLightYellow(
    Object? message, [
    @visibleForTesting int initialStackLevel = 0,
  ]) {
    return log(
      message: message,
      messageStyle: AnsiStyle.fgYellow,
      includePath: false,
      initialStackLevel: initialStackLevel,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage printLightBlue(
    Object? message, [
    @visibleForTesting int initialStackLevel = 0,
  ]) {
    return log(
      message: message,
      messageStyle: AnsiStyle.fgLightBlue,
      includePath: false,
      initialStackLevel: initialStackLevel,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage printLightPurple(
    Object? message, [
    @visibleForTesting int initialStackLevel = 0,
  ]) {
    return log(
      message: message,
      messageStyle: AnsiStyle.fgLightPurple,
      includePath: false,
      initialStackLevel: initialStackLevel,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage printLightCyan(
    Object? message, [
    @visibleForTesting int initialStackLevel = 0,
  ]) {
    return log(
      message: message,
      messageStyle: AnsiStyle.fgLightCyan,
      includePath: false,
      initialStackLevel: initialStackLevel,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage printLightWhite(
    Object? message, [
    @visibleForTesting int initialStackLevel = 0,
  ]) {
    return log(
      message: message,
      messageStyle: AnsiStyle.fgLightWhite,
      includePath: false,
      initialStackLevel: initialStackLevel,
    );
  }

  //
  //
  //

  @pragma('vm:prefer-inline')
  static _LogMessage log({
    _IconCategory? category,
    Object? message,
    Object? metadata,
    AnsiStyle? messageStyle,
    AnsiStyle? nonMessageStyle,
    Set<Symbol> tags = const {},
    bool includePath = true,
    int initialStackLevel = 0,
  }) {
    var inReleaseMode = true;
    assert(() {
      inReleaseMode = false;
      _printLog(
        message: message,
        metadata: metadata,
        category: category,
        messageStyle: messageStyle,
        nonMessageStyle: nonMessageStyle,
        tags: tags,
        includePath: includePath,
        initialStackLevel: initialStackLevel + 6,
      );
      return true;
    }());
    if (inReleaseMode && enableReleaseAsserts) {
      _printLog(
        message: message,
        metadata: metadata,
        category: category,
        messageStyle: messageStyle,
        nonMessageStyle: nonMessageStyle,
        tags: tags,
        includePath: includePath,
        initialStackLevel: initialStackLevel + 5,
      );
    }

    return _LogMessage(message?.toString());
  }

  //
  //
  //

  @pragma('vm:prefer-inline')
  static void _printLog({
    required Object? message,
    required Object? metadata,
    required _IconCategory? category,
    required AnsiStyle? messageStyle,
    required AnsiStyle? nonMessageStyle,
    required Set<Symbol> tags,
    required bool includePath,
    required int initialStackLevel,
  }) {
    // Maybe get the basepath.
    String? location;
    Frame? frame;
    if (includePath) {
      frame = Here(max(0, initialStackLevel - 1)).call().orNull();
      location = _shortLocation(frame?.location, frame?.member);
    }

    // Combine tags with the tag from category.
    final combinedTags = {...tags, if (category != null) category.tag};

    // Create a item to log.
    final logItem = LogItem(
      location: location,
      icon: category?.icon,
      message: message,
      metadata: metadata,
      tags: combinedTags,
      showId: showIds,
      showTags: showTags,
      showTimestamp: showTimestamps,
      frame: frame,
    );

    // Remove old logs.
    if (storeLogs) {
      if (items.length >= maxStoredLogs) {
        items.removeFirst();
      }
      // Maybe store new logs.
      items.add(logItem);
    }

    // Execute all callbacks and catch errors.
    final callbackErrors = <Object>[];
    for (final callback in callbacks) {
      try {
        callback(logItem);
      } catch (e) {
        callbackErrors.add(e);
      }
    }

    // Only print if combinedTags is empty or any of combinedTags are in activeTags.
    if (combinedTags.isNotEmpty &&
        !activeTags.any((e) => combinedTags.contains(e))) {
      // Throw any errors before returning.
      for (final e in callbackErrors) {
        throw e;
      }
      return;
    }

    // Print either styled or not styled using _printFunction.
    final output = enableStyling
        ? logItem.toStyledConsoleString(
            messageStyle: messageStyle,
            nonMessageStyle: nonMessageStyle,
          )
        : logItem.toConsoleString();
    _printFunction(output);
    // Throw any errors before returning.
    for (final e in callbackErrors) {
      throw e;
    }
  }

  //
  //
  //
}

@Deprecated('Use "Log" instead!')
typedef Glog = Log;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

String? _shortLocation(String? location, String? member) {
  if (location == null) {
    return null;
  }
  final parts = location.split(RegExp(r'\s+'));
  final path = parts.first;
  final line = parts.last.split(':').first;
  final file = path.split('/').last.replaceAll('.dart', '');
  return [
    if (path.startsWith('package:')) '${path.split(':')[1].split('/').first}:',
    file,
    if (member != null) ...['/$member'],
    ' #$line',
  ].join();
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

enum _IconCategory {
  //
  //
  //

  TRACE('⚪️', #trace),
  ERR('🔴', #err),
  ALERT('🟠', #alert),
  IGNORE('🟡', #ignore),
  OK('🟢', #ok),
  START('🔵', #start),
  STOP('⚫', #stop),
  INFO('🟣', #info),
  MESSAGE('🟤', #message);

  //
  //
  //

  final String icon;
  final Symbol tag;

  //
  //
  //

  const _IconCategory(this.icon, this.tag);
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

final class _LogMessage {
  //
  //
  //

  final String? message;

  //
  //
  //

  const _LogMessage(this.message);

  //
  //
  //

  @override
  String toString() => '[LogMessage] ${message ?? 'null'}';
}
