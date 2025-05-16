//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Dart/Flutter (DF) Packages by DevCetra.com & contributors. The use of this
// source code is governed by an MIT-style license described in the LICENSE
// file located in this project's root directory.
//
// See: https://opensource.org/license/mit
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:stack_trace/stack_trace.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

final class Here {
  //
  //
  //

  final int initialStackLevel;

  //
  //
  //

  const Here(this.initialStackLevel) : assert(initialStackLevel >= 0);

  //
  //
  //

  Frame? call() {
    final frames = Trace.current().frames;
    for (var i = initialStackLevel; i < frames.length; i++) {
      final frame = frames[i];

      final lineNumber = frame.line;
      final columnNumber = frame.column;
      if (lineNumber != null && columnNumber != null) {
        return frame;
      }
    }
    return null;
  }

  //
  //
  //

  /// The URI of the file in which the code is located.
  ///
  /// This URI will usually have the scheme `dart`, `file`, `http`, or `https`.
  static Uri? get uri => const Here(2)()?.uri;

  /// The line number on which the code location is located.
  ///
  /// This can be null, indicating that the line number is unknown or
  /// unimportant.
  static int? get line => const Here(2)()?.line;

  /// The column number of the code location.
  ///
  /// This can be null, indicating that the column number is unknown or
  /// unimportant.
  static int? get column => const Here(2)()?.column;

  /// The name of the member in which the code location occurs.
  ///
  /// Anonymous closures are represented as `<fn>` in this member string.
  static String? get member => const Here(2)()?.member;

  /// Returns a human-friendly description of the library that this stack frame
  /// comes from.
  ///
  /// This will usually be the string form of [uri], but a relative URI will be
  /// used if possible. Data URIs will be truncated.
  static String? get library => const Here(2)()?.library;

  /// Returns the name of the package this stack frame comes from, or `null` if
  /// this stack frame doesn't come from a `package:` URL.
  static String? get package => const Here(2)()?.package;

  /// A human-friendly description of the code location.
  static String? get location => const Here(2)()?.location;
}
