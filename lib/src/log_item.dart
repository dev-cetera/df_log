//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Source code by dev-cetera.com & contributors. The use of this source code is
// governed by an MIT-style license described in the LICENSE file located in
// this project's root directory.
//
// See: https://opensource.org/license/mit
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import '/_common.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

final class LogItem {
  //
  //
  //

  final String id;
  final DateTime timestamp;
  final Frame? frame;
  final String? location;
  final String? icon;
  final Object? message;
  final Object? metadata;
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
    required this.location,
    required this.icon,
    required this.message,
    required this.metadata,
    required this.tags,
    required this.showId,
    required this.showTags,
    required this.showTimestamp,
    required this.frame,
  })  : id = const Uuid().v4(),
        timestamp = DateTime.now();

  //
  //
  //

  String toConsoleString() {
    final buffer = StringBuffer();
    final hasPath = location != null && location!.isNotEmpty;

    if (hasPath) {
      buffer.write('[');
      if (icon != null) {
        buffer.write('$icon ');
      }
      buffer.write(location);
      if (showTimestamp) {
        final isoString = timestamp.toLocal().toIso8601String();
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
    final location1 = location;
    final hasLocation = location1 != null && location1.isNotEmpty;

    if (hasLocation) {
      final bracketStyle =
          nonMessageStyle != null ? AnsiStyle.bold + nonMessageStyle : null;
      final pathTextStyle =
          nonMessageStyle != null ? AnsiStyle.italic + nonMessageStyle : null;
      if (icon != null) {
        buffer.write('$icon ');
      }
      buffer.write('['.withAnsiStyle(bracketStyle));
      buffer.write(location1.withAnsiStyle(pathTextStyle));

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
    final column = frame?.column;
    final library = frame?.library;
    final line = frame?.line;
    final package = frame?.package;
    final uri = frame?.uri.toString();

    return {
      'icon': icon != null && (location != null && location!.isNotEmpty)
          ? icon
          : null,
      'location': location != null && location!.isNotEmpty ? location : null,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'tags': tags.isNotEmpty ? tags.map(_unmangleSymbol).toList() : null,
      'id': id,
      'column': column,
      'line': line,
      'package': package,
      'library': library,
      'uri': uri,
    };
  }

  //
  //
  //

  String toJson({bool pretty = true}) {
    final map = toMap();
    final encoder =
        pretty ? const JsonEncoder.withIndent('  ') : const JsonEncoder();
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
