//title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
// Dart/Flutter (DF) Packages by dev-cetera.com & contributors. The use of this
// source code is governed by an MIT-style license described in the LICENSE
// file located in this project's root directory.
//
// See: https://opensource.org/license/mit
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//title~

import 'package:df_safer_dart/df_safer_dart.dart' show Here;
import 'package:meta/meta.dart' show visibleForTesting;
import 'dart:developer' as developer;
import 'dart:collection' show Queue;

import '_src.g.dart';

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
  static var activeTags = {
    #debug,
    ..._IconCategory.values.map((e) => e.tag),
  };

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

  static int _maxStoredLogs = 1000;

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
  static var enableStyling = true;

  @Deprecated('Use "enableStyling" instead!')
  static bool get stylize => enableStyling;

  @Deprecated('Use "enableStyling" instead!')
  static set stylize(bool value) => enableStyling = value;

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
    dynamic message, [
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
    dynamic message, [
    Set<Symbol> tags = const {},
    @visibleForTesting int initialStackLevel = 0,
  ]) {
    return log(
      message: message,
      category: _IconCategory.ERROR,
      tags: tags,
      nonMessageStyle: AnsiStyle.fgLightBlack,
      initialStackLevel: initialStackLevel,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage alert(
    dynamic message, [
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
    dynamic message, [
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
    dynamic message, [
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
    dynamic message, [
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
    dynamic message, [
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
    dynamic message, [
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
    dynamic message, [
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
    required _IconCategory? category,
    required AnsiStyle? messageStyle,
    required AnsiStyle? nonMessageStyle,
    required Set<Symbol> tags,
    required bool includePath,
    required int initialStackLevel,
  }) {
    // Maybe get the basepath.
    String? basepath;
    if (includePath) {
      basepath = Here(initialStackLevel).basepath;
    }

    // Combine tags with the tag from category.
    final combinedTags = {
      ...tags,
      if (category != null) category.tag,
    };

    // Create a item to log.
    final logItem = LogItem(
      basepath: basepath,
      icon: category?.icon,
      message: message,
      tags: combinedTags,
      showId: showIds,
      showTags: showTags,
      showTimestamp: showTimestamps,
    );

    // Remove old logs.
    if (storeLogs) {
      if (items.length >= maxStoredLogs) {
        items.removeFirst();
      }
      // Maybe store new logs.
      items.add(logItem);
    }

    // Execute all callbacks.
    for (final callback in callbacks) {
      callback(logItem);
    }

    // Only print if combinedTags is empty or all of combinedTags are in activeTags.
    if (combinedTags.isNotEmpty && !activeTags.containsAll(combinedTags)) {
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
  }

  //
  //
  //
}

@Deprecated('Use "Log" instead!')
typedef Glog = Log;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

enum _IconCategory {
  //
  //
  //

  TRACE('⚪️', #trace),
  ERROR('🔴', #error),
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

  const _IconCategory(
    this.icon,
    this.tag,
  );
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
