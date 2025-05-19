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
import 'dart:developer';

import '_src.g.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

final class Glog {
  //
  //
  //

  const Glog();

  //
  //
  //

  @pragma('vm:prefer-inline')
  static _GlogMessage trace(dynamic message, [Symbol? group]) {
    return glog(
      message: message,
      category: GlogCategory.TRACE,
      group: group,
      pathStyle: AnsiStyle.fgLightBlack,
    );
  }

  @pragma('vm:prefer-inline')
  static _GlogMessage err(dynamic message, [Symbol? group]) {
    return glog(
      message: message,
      category: GlogCategory.ERROR,
      group: group,
      pathStyle: AnsiStyle.fgLightBlack,
    );
  }

  @pragma('vm:prefer-inline')
  static _GlogMessage alert(dynamic message, [Symbol? group]) {
    return glog(
      message: message,
      category: GlogCategory.ALERT,
      group: group,
      pathStyle: AnsiStyle.fgLightBlack,
    );
  }

  @pragma('vm:prefer-inline')
  static _GlogMessage ignore(dynamic message, [Symbol? group]) {
    return glog(
      message: message,
      category: GlogCategory.IGNORE,
      group: group,
      pathStyle: AnsiStyle.fgLightBlack,
      messageStyle: AnsiStyle.strikethrough,
    );
  }

  @pragma('vm:prefer-inline')
  static _GlogMessage ok(dynamic message, [Symbol? group]) {
    return glog(
      message: message,
      category: GlogCategory.OK,
      group: group,
      pathStyle: AnsiStyle.fgLightBlack,
    );
  }

  @pragma('vm:prefer-inline')
  static _GlogMessage start(dynamic message, [Symbol? group]) {
    return glog(
      message: message,
      category: GlogCategory.START,
      group: group,
      pathStyle: AnsiStyle.fgLightBlack,
    );
  }

  @pragma('vm:prefer-inline')
  static _GlogMessage stop(dynamic message, [Symbol? group]) {
    return glog(
      message: message,
      category: GlogCategory.STOP,
      group: group,
      pathStyle: AnsiStyle.fgLightBlack,
    );
  }

  @pragma('vm:prefer-inline')
  static _GlogMessage info(dynamic message, [Symbol? group]) {
    return glog(
      message: message,
      category: GlogCategory.INFO,
      group: group,
      pathStyle: AnsiStyle.fgLightBlack,
    );
  }

  @pragma('vm:prefer-inline')
  static _GlogMessage message(dynamic message, [Symbol? group]) {
    return glog(
      message: message,
      category: GlogCategory.MESSAGE,
      group: group,
      pathStyle: AnsiStyle.fgLightBlack,
    );
  }

  @pragma('vm:prefer-inline')
  static _GlogMessage printBlack(Object? message) {
    return glog(
      message: message,
      messageStyle: AnsiStyle.fgBlack,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static _GlogMessage printRed(Object? message) {
    return glog(
      message: message,
      messageStyle: AnsiStyle.fgRed,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static _GlogMessage printGreen(Object? message) {
    return glog(
      message: message,
      messageStyle: AnsiStyle.fgGreen,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static _GlogMessage printYellow(Object? message) {
    return glog(
      message: message,
      messageStyle: AnsiStyle.fgYellow,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static _GlogMessage printBlue(Object? message) {
    return glog(
      message: message,
      messageStyle: AnsiStyle.fgBlue,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static _GlogMessage printPurple(Object? message) {
    return glog(
      message: message,
      messageStyle: AnsiStyle.fgPurple,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static _GlogMessage printCyan(Object? message) {
    return glog(
      message: message,
      messageStyle: AnsiStyle.fgCyan,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static _GlogMessage printWhite(Object? message) {
    return glog(
      message: message,
      messageStyle: AnsiStyle.fgWhite,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static _GlogMessage printLightBlack(Object? message) {
    return glog(
      message: message,
      messageStyle: AnsiStyle.fgLightBlack,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static _GlogMessage printLightRed(Object? message) {
    return glog(
      message: message,
      messageStyle: AnsiStyle.fgRed,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static _GlogMessage printLightGreen(Object? message) {
    return glog(
      message: message,
      messageStyle: AnsiStyle.fgLightGreen,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static _GlogMessage lightYellow(Object? message) {
    return glog(
      message: message,
      messageStyle: AnsiStyle.fgYellow,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static _GlogMessage lightBlue(Object? message) {
    return glog(
      message: message,
      messageStyle: AnsiStyle.fgLightBlue,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static _GlogMessage lightPurple(Object? message) {
    return glog(
      message: message,
      messageStyle: AnsiStyle.fgLightPurple,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static _GlogMessage lightCyan(Object? message) {
    return glog(
      message: message,
      messageStyle: AnsiStyle.fgLightCyan,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static _GlogMessage lightWhite(Object? message) {
    return glog(
      message: message,
      messageStyle: AnsiStyle.fgLightWhite,
      includePath: false,
    );
  }

  /// A whitelist of groups to log.
  static const whitelist = {#debug};

  /// A list of logs.
  static final items = <GlogItem>[];

  /// A callback that is called when a log is added.
  static final callbacks = <void Function(Symbol? group, GlogItem item)>[];

  /// Adds a callback that is called when a log is added. Returns the callback
  /// function so it can be removed later.
  void Function(Symbol? group, GlogItem item) addCallback(
    void Function(Symbol? group, GlogItem GlogItem) callback,
  ) {
    callbacks.add(callback);
    return callback;
  }

  /// Removes a callback that is called when a log is added.
  void removeCallback(void Function(GlogItem item) callback) {
    callbacks.remove(callback);
  }

  /// Whether to stylize the logs.
  static bool stylize = false;

  static var _printFunction = print;

  /// Sets the print function as [log].
  void useLogForPrinting() {
    _printFunction = (e) {
      log(e.toString());
    };
  }

  /// Sets the print function as [print].
  void usePrintForPrinting() {
    _printFunction = (e) {
      print(e);
    };
  }

  @pragma('vm:prefer-inline')
  static _GlogMessage glog({
    GlogCategory? category,
    Object? message,
    AnsiStyle? messageStyle,
    AnsiStyle? pathStyle,
    Symbol? group,
    Set<Symbol> whitelist = const {#debug},
    bool includePath = true,
    int initialStackLevel = 3,
  }) {
    String? basepath;
    if (includePath) {
      basepath = Here(initialStackLevel).basepath;
    }
    final item = GlogItem(
      basepath: basepath,
      message: message,
      category: category ?? GlogCategory.MESSAGE,
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
          final pathStyle1 =
              pathStyle != null ? AnsiStyle.italic + pathStyle : null;
          final bracketsStyle =
              pathStyle != null ? AnsiStyle.bold + pathStyle : null;
          final path1 = basepath?.withAnsiStyle(pathStyle1);
          final path2 =
              path1 != null && path1.isNotEmpty
                  ? '['.withAnsiStyle(bracketsStyle) +
                      path1 +
                      ']'.withAnsiStyle(bracketsStyle)
                  : null;
          final message1 = message.toString().trim();
          final message2 = message1.withAnsiStyle(messageStyle);
          output = [
            if (path2 != null) category?.icon,
            path2,
            message2,
          ].nonNulls.join(' ');
        } else {
          final path2 =
              basepath != null && basepath.isNotEmpty ? '[$basepath]' : null;
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
    return _GlogMessage(message?.toString());
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

enum GlogCategory {
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

  const GlogCategory(this.icon);
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Represents a single log entry with path, message, and category.
class GlogItem {
  final String? basepath;
  final Object? message;
  final GlogCategory? category;

  const GlogItem({this.basepath, this.message, this.category});

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

class _GlogMessage {
  final String? message;

  const _GlogMessage(this.message);

  @override
  String toString() => '[GlogMessage] ${message ?? '???'}';
}
