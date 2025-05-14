//title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
// Dart/Flutter (DF) Packages by dev-cetera.com & contributors. The use of this
// source code is governed by an MIT-style license described in the LICENSE
// file located in this project's root directory.
//
// See: https://opensource.org/license/mit
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//title~

import 'package:path/path.dart' as p;
import 'dart:developer';

import '_src.g.dart';
import 'ansi_styled_string.dart';

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
  static void trace(
    dynamic message, [
    Symbol? group,
  ]) {
    glog(
      message: message,
      category: GlogCategory.TRACE,
      group: group,
      pathStyle: AnsiStyle.fgLightBlack,
    );
  }

  @pragma('vm:prefer-inline')
  static void err(
    dynamic message, [
    Symbol? group,
  ]) {
    glog(
      message: message,
      category: GlogCategory.ERROR,
      group: group,
      pathStyle: AnsiStyle.fgLightBlack,
    );
  }

  @pragma('vm:prefer-inline')
  static void alert(
    dynamic message, [
    Symbol? group,
  ]) {
    glog(
      message: message,
      category: GlogCategory.ALERT,
      group: group,
      pathStyle: AnsiStyle.fgLightBlack,
    );
  }

  @pragma('vm:prefer-inline')
  static void ignore(
    dynamic message, [
    Symbol? group,
  ]) {
    glog(
      message: message,
      category: GlogCategory.IGNORE,
      group: group,
      pathStyle: AnsiStyle.fgLightBlack,
      messageStyle: AnsiStyle.strikethrough,
    );
  }

  @pragma('vm:prefer-inline')
  static void ok(
    dynamic message, [
    Symbol? group,
  ]) {
    glog(
      message: message,
      category: GlogCategory.OK,
      group: group,
      pathStyle: AnsiStyle.fgLightBlack,
    );
  }

  @pragma('vm:prefer-inline')
  static void start(
    dynamic message, [
    Symbol? group,
  ]) {
    glog(
      message: message,
      category: GlogCategory.START,
      group: group,
      pathStyle: AnsiStyle.fgLightBlack,
    );
  }

  @pragma('vm:prefer-inline')
  static void stop(
    dynamic message, [
    Symbol? group,
  ]) {
    glog(
      message: message,
      category: GlogCategory.STOP,
      group: group,
      pathStyle: AnsiStyle.fgLightBlack,
    );
  }

  @pragma('vm:prefer-inline')
  static void info(
    dynamic message, [
    Symbol? group,
  ]) {
    glog(
      message: message,
      category: GlogCategory.INFO,
      group: group,
      pathStyle: AnsiStyle.fgLightBlack,
    );
  }

  @pragma('vm:prefer-inline')
  static void message(
    dynamic message, [
    Symbol? group,
  ]) {
    glog(
      message: message,
      category: GlogCategory.MESSAGE,
      group: group,
      pathStyle: AnsiStyle.fgLightBlack,
    );
  }

  @pragma('vm:prefer-inline')
  static void printBlack(Object? message) {
    glog(
      message: message,
      messageStyle: AnsiStyle.fgBlack,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static void printRed(Object? message) {
    glog(
      message: message,
      messageStyle: AnsiStyle.fgRed,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static void printGreen(Object? message) {
    glog(
      message: message,
      messageStyle: AnsiStyle.fgGreen,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static void printYellow(Object? message) {
    glog(
      message: message,
      messageStyle: AnsiStyle.fgYellow,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static void printBlue(Object? message) {
    glog(
      message: message,
      messageStyle: AnsiStyle.fgBlue,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static void printPurple(Object? message) {
    glog(
      message: message,
      messageStyle: AnsiStyle.fgPurple,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static void printCyan(Object? message) {
    glog(
      message: message,
      messageStyle: AnsiStyle.fgCyan,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static void printWhite(Object? message) {
    glog(
      message: message,
      messageStyle: AnsiStyle.fgWhite,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static void printLightBlack(Object? message) {
    glog(
      message: message,
      messageStyle: AnsiStyle.fgLightBlack,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static void printLightRed(Object? message) {
    glog(
      message: message,
      messageStyle: AnsiStyle.fgRed,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static void printLightGreen(Object? message) {
    glog(
      message: message,
      messageStyle: AnsiStyle.fgLightGreen,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static void lightYellow(Object? message) {
    glog(
      message: message,
      messageStyle: AnsiStyle.fgYellow,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static void lightBlue(Object? message) {
    glog(
      message: message,
      messageStyle: AnsiStyle.fgLightBlue,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static void lightPurple(Object? message) {
    glog(
      message: message,
      messageStyle: AnsiStyle.fgLightPurple,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static void lightCyan(Object? message) {
    glog(
      message: message,
      messageStyle: AnsiStyle.fgLightCyan,
      includePath: false,
    );
  }

  @pragma('vm:prefer-inline')
  static void lightWhite(Object? message) {
    glog(
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
  static bool stylize = true;

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
  static void glog({
    GlogCategory? category,
    Object? message,
    AnsiStyle? messageStyle,
    AnsiStyle? pathStyle,
    Symbol? group,
    Set<Symbol> whitelist = const {#debug},
    bool includePath = true,
  }) {
    String? path;
    if (includePath) {
      final here = const Here(3).call();
      path =
          here != null ? [p.basenameWithoutExtension(here.library), here.member].join('/') : null;
    }
    final item = GlogItem(
      path: path,
      message: message,
      category: category ?? GlogCategory.MESSAGE,
    );
    items.add(item);
    for (var e in callbacks) {
      e(group, item);
    }

    // No cost in debug mode.
    assert(() {
      if (group == null || {...whitelist, ...whitelist}.contains(group)) {
        String output;
        if (stylize) {
          final pathStyle1 = pathStyle != null ? AnsiStyle.italic + pathStyle : null;
          final bracketsStyle = pathStyle != null ? AnsiStyle.bold + pathStyle : null;
          final path1 = path?.withAnsiStyle(pathStyle1);
          final path2 = path1 != null && path1.isNotEmpty
              ? '['.withAnsiStyle(bracketsStyle) + path1 + ']'.withAnsiStyle(bracketsStyle)
              : null;
          final message1 = message.toString().trim();
          final message2 = message1.withAnsiStyle(messageStyle);
          output = [if (path2 != null) category?.icon, path2, message2].nonNulls.join(' ');
        } else {
          final path2 = path != null && path.isNotEmpty ? '[$path]' : null;
          final message2 = message.toString();
          output = [if (path2 != null) category?.icon, path2, message2].nonNulls.join(' ');
        }
        _printFunction(output);
      }
      return true;
    }());
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

  const GlogCategory(
    this.icon,
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Represents a single log entry with path, message, and category.
class GlogItem {
  final String? path;
  final Object? message;
  final GlogCategory? category;

  const GlogItem({
    this.path,
    this.message,
    this.category,
  });

  @override
  String toString() {
    final path1 = path != null && path!.isEmpty ? '[$path]' : null;
    final message1 = message.toString().trim();
    return [if (path1 != null) category?.icon, path1, message1].nonNulls.join(' ');
  }
}
