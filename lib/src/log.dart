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
import 'dart:developer' as developer;

import '_src.g.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

@Deprecated('Use "Log" instead')
typedef Glog = Log;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

final class Log {
  //
  //
  //

  const Log();

  //
  //
  //

  @pragma('vm:prefer-inline')
  static _LogMessage trace(dynamic message, [Symbol? group]) {
    return log(
      message: message,
      category: LogCategory.TRACE,
      group: group,
      pathStyle: AnsiStyle.fgLightBlack,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage err(dynamic message, [Symbol? group]) {
    return log(
      message: message,
      category: LogCategory.ERROR,
      group: group,
      pathStyle: AnsiStyle.fgLightBlack,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage alert(dynamic message, [Symbol? group]) {
    return log(
      message: message,
      category: LogCategory.ALERT,
      group: group,
      pathStyle: AnsiStyle.fgLightBlack,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage ignore(dynamic message, [Symbol? group]) {
    return log(
      message: message,
      category: LogCategory.IGNORE,
      group: group,
      pathStyle: AnsiStyle.fgLightBlack,
      messageStyle: AnsiStyle.strikethrough,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage ok(dynamic message, [Symbol? group]) {
    return log(
      message: message,
      category: LogCategory.OK,
      group: group,
      pathStyle: AnsiStyle.fgLightBlack,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage start(dynamic message, [Symbol? group]) {
    return log(
      message: message,
      category: LogCategory.START,
      group: group,
      pathStyle: AnsiStyle.fgLightBlack,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage stop(dynamic message, [Symbol? group]) {
    return log(
      message: message,
      category: LogCategory.STOP,
      group: group,
      pathStyle: AnsiStyle.fgLightBlack,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage info(dynamic message, [Symbol? group]) {
    return log(
      message: message,
      category: LogCategory.INFO,
      group: group,
      pathStyle: AnsiStyle.fgLightBlack,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage message(dynamic message, [Symbol? group]) {
    return log(
      message: message,
      category: LogCategory.MESSAGE,
      group: group,
      pathStyle: AnsiStyle.fgLightBlack,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage printBlack(Object? message) {
    return log(
      message: message,
      messageStyle: AnsiStyle.fgBlack,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage printRed(Object? message) {
    return log(
      message: message,
      messageStyle: AnsiStyle.fgRed,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage printGreen(Object? message) {
    return log(
      message: message,
      messageStyle: AnsiStyle.fgGreen,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage printYellow(Object? message) {
    return log(
      message: message,
      messageStyle: AnsiStyle.fgYellow,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage printBlue(Object? message) {
    return log(
      message: message,
      messageStyle: AnsiStyle.fgBlue,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage printPurple(Object? message) {
    return log(
      message: message,
      messageStyle: AnsiStyle.fgPurple,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage printCyan(Object? message) {
    return log(
      message: message,
      messageStyle: AnsiStyle.fgCyan,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage printWhite(Object? message) {
    return log(
      message: message,
      messageStyle: AnsiStyle.fgWhite,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage printLightBlack(Object? message) {
    return log(
      message: message,
      messageStyle: AnsiStyle.fgLightBlack,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage printLightRed(Object? message) {
    return log(
      message: message,
      messageStyle: AnsiStyle.fgRed,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage printLightGreen(Object? message) {
    return log(
      message: message,
      messageStyle: AnsiStyle.fgLightGreen,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage lightYellow(Object? message) {
    return log(
      message: message,
      messageStyle: AnsiStyle.fgYellow,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage lightBlue(Object? message) {
    return log(
      message: message,
      messageStyle: AnsiStyle.fgLightBlue,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage lightPurple(Object? message) {
    return log(
      message: message,
      messageStyle: AnsiStyle.fgLightPurple,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage lightCyan(Object? message) {
    return log(
      message: message,
      messageStyle: AnsiStyle.fgLightCyan,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static _LogMessage lightWhite(Object? message) {
    return log(
      message: message,
      messageStyle: AnsiStyle.fgLightWhite,
      includePath: false,
    );
  }

  /// A whitelist of groups to log.
  static const whitelist = {#debug};

  /// A list of logs.
  static final items = <LogItem>[];

  /// A callback that is called when a log is added.
  static final callbacks = <void Function(Symbol? group, LogItem item)>[];

  /// Adds a callback that is called when a log is added. Returns the callback
  /// function so it can be removed later.
  void Function(Symbol? group, LogItem item) addCallback(
    void Function(Symbol? group, LogItem LogItem) callback,
  ) {
    callbacks.add(callback);
    return callback;
  }

  /// Removes a callback that is called when a log is added.
  void removeCallback(void Function(LogItem item) callback) {
    callbacks.remove(callback);
  }

  /// Whether to stylize the logs.
  static bool stylize = false;

  static var _printFunction = print;

  /// Sets the print function as [log].
  void useLogForPrinting() {
    _printFunction = (e) {
      developer.log(e.toString());
    };
  }

  /// Sets the print function as [print].
  void usePrintForPrinting() {
    _printFunction = (e) {
      print(e);
    };
  }

  @pragma('vm:prefer-inline')
  static _LogMessage log({
    LogCategory? category,
    Object? message,
    AnsiStyle? messageStyle,
    AnsiStyle? pathStyle,
    Symbol? group,
    Set<Symbol> whitelist = const {#debug},
    bool includePath = true,
    int initialStackLevel = 4,
  }) {
    String? basepath;
    if (includePath) {
      basepath = Here(initialStackLevel).basepath;
    }
    final item = LogItem(
      basepath: basepath,
      message: message,
      category: category ?? LogCategory.MESSAGE,
    );
    items.add(item);
    for (var e in callbacks) {
      e(group, item);
    }

    // No cost in debug mode.
    assert(() {
      String? output;
      if (group == null || {...whitelist, ...whitelist}.contains(group)) {
        if (stylize) {
          final pathStyle1 = pathStyle != null ? AnsiStyle.italic + pathStyle : null;
          final bracketsStyle = pathStyle != null ? AnsiStyle.bold + pathStyle : null;
          final path1 = basepath?.withAnsiStyle(pathStyle1);
          final path2 = path1 != null && path1.isNotEmpty
              ? '['.withAnsiStyle(bracketsStyle) + path1 + ']'.withAnsiStyle(bracketsStyle)
              : null;
          final message1 = message.toString().trim();
          final message2 = message1.withAnsiStyle(messageStyle);
          output = [
            if (path2 != null) category?.icon,
            path2,
            message2,
          ].nonNulls.join(' ');
        } else {
          final path2 = basepath != null && basepath.isNotEmpty ? '[$basepath]' : null;
          final message2 = message.toString();
          output = [
            if (path2 != null) category?.icon,
            path2,
            message2,
          ].nonNulls.join(' ');
        }
        _printFunction(output);
      }
      return true;
    }());
    return _LogMessage(message?.toString());
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

enum LogCategory {
  //
  //
  //

  TRACE('⚪️'),
  ERROR('🔴'),
  ALERT('🟠'),
  IGNORE('🟡'),
  OK('🟢'),
  START('🔵'),
  STOP('⚫'),
  INFO('🟣'),
  MESSAGE('🟤');

  //
  //
  //

  final String icon;

  //
  //
  //

  const LogCategory(this.icon);
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Represents a single log entry with path, message, and category.
class LogItem {
  final String? basepath;
  final Object? message;
  final LogCategory? category;

  const LogItem({this.basepath, this.message, this.category});

  @override
  String toString() {
    final path1 = basepath != null && basepath!.isEmpty ? '[$basepath]' : null;
    final message1 = message.toString().trim();
    return [
      if (path1 != null) category?.icon,
      path1,
      message1,
    ].nonNulls.join(' ');
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class _LogMessage {
  final String? message;

  const _LogMessage(this.message);

  @override
  String toString() => '[LogMessage] ${message ?? '???'}';
}
