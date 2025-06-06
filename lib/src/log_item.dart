//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Dart/Flutter (DF) Packages by dev-cetera.com & contributors. The use of this
// source code is governed by an MIT-style license described in the LICENSE
// file located in this project's root directory.
//
// See: https://opensource.org/license/mit
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'dart:convert' show JsonEncoder;

import 'package:uuid/uuid.dart';

import 'ansi_styled_string.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

final class LogItem {
  //
  //
  //

  final String id;
  final DateTime timestamp;
  final String? basepath;
  final String? icon;
  final Object? message;
  final Set<Symbol> tags;

  //
  //
  //

  final bool showId;
  final bool showTags;
  final bool showTimestamp;

  //
  //
  //

  LogItem({
    this.basepath,
    this.icon,
    this.message,
    this.tags = const {},
    this.showId = false,
    this.showTags = true,
    this.showTimestamp = false,
  }) : id = const Uuid().v4(),
       timestamp = DateTime.now();

  //
  //
  //

  String toConsoleString() {
    final buffer = StringBuffer();
    final hasPath = basepath != null && basepath!.isNotEmpty;

    if (hasPath) {
      buffer.write('[');
      if (icon != null) {
        buffer.write('$icon ');
      }
      buffer.write(basepath);
      if (showTimestamp) {
        final isoString = timestamp.toLocal().toIso8601String();
        // Grabs 'HH:mm:ss.SSS'
        final timeStr = isoString.substring(11, 23);
        buffer.write(' @$timeStr');
      }
      buffer.write('] ');
    }

    if (message != null) {
      buffer.write(message.toString().trim());
    }

    if (showTags && tags.isNotEmpty) {
      final tagStrings = tags.map((s) => '#${_unmangleSymbol(s)}').join(' ');
      buffer.write(' $tagStrings');
    }

    if (showId) {
      buffer.write(' <$id>');
    }

    return buffer.toString().trim();
  }

  //
  //
  //

  String toStyledConsoleString({
    required AnsiStyle? messageStyle,
    required AnsiStyle? nonMessageStyle,
  }) {
    final buffer = StringBuffer();
    final basepath1 = basepath;
    final hasPath = basepath1 != null && basepath1.isNotEmpty;

    if (hasPath) {
      final bracketStyle = nonMessageStyle != null
          ? AnsiStyle.bold + nonMessageStyle
          : null;
      final pathTextStyle = nonMessageStyle != null
          ? AnsiStyle.italic + nonMessageStyle
          : null;
      if (icon != null) {
        buffer.write('$icon ');
      }
      buffer.write('['.withAnsiStyle(bracketStyle));
      buffer.write(basepath1.withAnsiStyle(pathTextStyle));

      if (showTimestamp) {
        final isoString = timestamp.toLocal().toIso8601String();
        final timeStr = isoString.substring(11, 23);
        buffer.write(' @$timeStr'.withAnsiStyle(pathTextStyle));
      }
      buffer.write('] '.withAnsiStyle(bracketStyle));
    }

    if (message != null) {
      final styledMessage = message.toString().trim().withAnsiStyle(
        messageStyle,
      );
      buffer.write(styledMessage);
    }

    if (showTags && tags.isNotEmpty) {
      final tagStrings = tags.map((s) => '#${_unmangleSymbol(s)}').join(' ');
      buffer.write(' $tagStrings'.withAnsiStyle(nonMessageStyle));
    }

    if (showId) {
      buffer.write(' <$id>'.withAnsiStyle(nonMessageStyle));
    }
    return buffer.toString();
  }

  //
  //
  //
  //

  Map<String, dynamic> toMap() {
    return {
      if (icon != null && (basepath != null && basepath!.isNotEmpty))
        'icon': icon,
      if (basepath != null && basepath!.isNotEmpty) 'path': basepath,
      if (message != null) 'message': message.toString(),
      'timestamp': timestamp.toIso8601String(),
      if (tags.isNotEmpty) 'tags': tags.map(_unmangleSymbol).toList(),
      'id': id,
    };
  }

  //
  //
  //

  String toJson({bool pretty = true}) {
    final map = toMap();
    final encoder = pretty
        ? const JsonEncoder.withIndent('  ')
        : const JsonEncoder();
    return encoder.convert(map);
  }

  //
  //
  //

  @override
  String toString() => toConsoleString();

  //
  //
  //

  static String _unmangleSymbol(Symbol symbol) {
    const a = 'Symbol("';
    const b = '")';
    final s = symbol.toString();
    return s.substring(a.length, s.length - b.length);
  }
}
