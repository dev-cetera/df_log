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

/// A class that provides a way to style strings with ANSI escape codes.
class AnsiStyle {
  //
  //
  //

  final List<int> _codes;

  //
  //
  //

  AnsiStyle(int code) : _codes = [code];

  //
  //
  //

  AnsiStyle._multiple(this._codes);

  //
  //
  //

  /// Combines two styles into one.
  AnsiStyle operator +(AnsiStyle other) {
    return AnsiStyle._multiple([..._codes, ...other._codes]);
  }

  //
  //
  //

  /// Formats the given value with the style.
  String formatted(Object? value) {
    var result = value.toString();
    for (final code in _codes) {
      result = result.withAnsiStyleCode(code);
    }
    return result;
  }

  //
  //
  //

  /// Adds a reset code.
  static AnsiStyle get escape => AnsiStyle(0);

  /// Adds a bold style.
  static AnsiStyle get bold => AnsiStyle(1);

  /// Adds a dim style.
  static AnsiStyle get dim => AnsiStyle(2);

  /// Adds an italic style.
  static AnsiStyle get italic => AnsiStyle(3);

  /// Adds an underline.
  static AnsiStyle get underline => AnsiStyle(4);

  /// Adds a blink.
  static AnsiStyle get blink => AnsiStyle(5);

  /// Adds a fast blink.
  static AnsiStyle get flicker => AnsiStyle(6);

  //
  //
  //

  /// Adds a reverse.
  static AnsiStyle get reverse => AnsiStyle(7);

  /// Adds a hidden.
  static AnsiStyle get cancelled => AnsiStyle(8);

  /// Adds a strikethrough.
  static AnsiStyle get strikethrough => AnsiStyle(9);

  //
  //
  //

  /// Adds style 11.
  static AnsiStyle get style11 => AnsiStyle(11);

  /// Adds style 12.
  static AnsiStyle get style12 => AnsiStyle(12);

  /// Adds style 13.
  static AnsiStyle get style13 => AnsiStyle(13);

  /// Adds style 14.
  static AnsiStyle get style14 => AnsiStyle(14);

  /// Adds style 15.
  static AnsiStyle get style15 => AnsiStyle(15);

  /// Adds h4 style.
  static AnsiStyle get h4 => AnsiStyle(16);

  /// Adds h3 style.
  static AnsiStyle get h3 => AnsiStyle(17);

  /// Adds h2 style.
  static AnsiStyle get h2 => AnsiStyle(18);

  /// Adds a tertiary heading style.
  static AnsiStyle get headingTertiary1 => AnsiStyle(19);

  /// Adds style 20.
  static AnsiStyle get style20 => AnsiStyle(20);

  /// Adds style 21.
  static AnsiStyle get style21 => AnsiStyle(21);

  //
  //
  //

  /// Adds a black foreground.
  static AnsiStyle get fgBlack => AnsiStyle(30);

  /// Adds a red foreground.
  static AnsiStyle get fgRed => AnsiStyle(31);

  /// Adds a green foreground.
  static AnsiStyle get fgGreen => AnsiStyle(32);

  /// Adds a yellow foreground.
  static AnsiStyle get fgYellow => AnsiStyle(33);

  /// Adds a blue foreground.
  static AnsiStyle get fgBlue => AnsiStyle(34);

  /// Adds a purple foreground.
  static AnsiStyle get fgPurple => AnsiStyle(35);

  /// Adds a cyan foreground.
  static AnsiStyle get fgCyan => AnsiStyle(36);

  /// Adds a white foreground.
  static AnsiStyle get fgWhite => AnsiStyle(37);

  //
  //
  //

  /// Adds a black background.
  static AnsiStyle get bgBlack => AnsiStyle(40);

  /// Adds a red background.
  static AnsiStyle get bgRed => AnsiStyle(41);

  /// Adds a green background.
  static AnsiStyle get bgGreen => AnsiStyle(42);

  /// Adds a yellow background.
  static AnsiStyle get bgYellow => AnsiStyle(43);

  /// Adds a blue background.
  static AnsiStyle get bgBlue => AnsiStyle(44);

  /// Adds a purple background.
  static AnsiStyle get bgPurple => AnsiStyle(45);

  /// Adds a cyan background.
  static AnsiStyle get bgCyan => AnsiStyle(46);

  /// Adds a white background.
  static AnsiStyle get bgWhite => AnsiStyle(47);

  //
  //
  //

  /// Adds a superscript.
  static AnsiStyle get superscript => AnsiStyle(48);

  /// Adds a subscript.
  static AnsiStyle get subscript => AnsiStyle(49);

  //
  //
  //

  /// Adds a light black foreground.
  static AnsiStyle get fgLightBlack => AnsiStyle(90);

  /// Adds a light red foreground.
  static AnsiStyle get fgLightRed => AnsiStyle(91);

  /// Adds a light green foreground.
  static AnsiStyle get fgLightGreen => AnsiStyle(92);

  /// Adds a light yellow foreground.
  static AnsiStyle get fgLightYellow => AnsiStyle(93);

  /// Adds a light blue foreground.
  static AnsiStyle get fgLightBlue => AnsiStyle(94);

  /// Adds a light purple foreground.
  static AnsiStyle get fgLightPurple => AnsiStyle(95);

  /// Adds a light cyan foreground.
  static AnsiStyle get fgLightCyan => AnsiStyle(96);

  /// Adds a light white foreground.
  static AnsiStyle get fgLightWhite => AnsiStyle(97);

  //
  //
  //

  /// Adds a light black background.
  static AnsiStyle get bgLightBlack => AnsiStyle(100);

  /// Adds a light red background.
  static AnsiStyle get bgLightRed => AnsiStyle(101);

  /// Adds a light green background.
  static AnsiStyle get bgLightGreen => AnsiStyle(102);

  /// Adds a light yellow background.
  static AnsiStyle get bgLightYellow => AnsiStyle(103);

  /// Adds a light blue background.
  static AnsiStyle get bgLightBlue => AnsiStyle(104);

  /// Adds a light purple background.
  static AnsiStyle get bgLightPurple => AnsiStyle(105);

  /// Adds a light cyan background.
  static AnsiStyle get bgLightCyan => AnsiStyle(106);

  /// Adds a light white background.
  static AnsiStyle get bgLightWhite => AnsiStyle(107);
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

extension WithAnsiStyleOnStringExtension on String {
  /// Adds the ANSI escape code to the string.
  String withAnsiStyleCode(int? code) {
    if (code == null) return this;
    return '\u001b[${code}m$this\u001b[0m';
  }

  /// Adds an ANSI style to the string.
  String withAnsiStyle(AnsiStyle? style) {
    if (style == null) return this;
    return style.formatted(this);
  }
}
