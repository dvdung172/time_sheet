import 'package:flutter/material.dart';

extension StringEx on String {
  /// Validate email
  bool isEmail() => RegExp(
          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
      .hasMatch(this);

  /// Get first letters from name
  /// Ex: Bill Gates => BG, Jonh Doe => JD
  String getLetterFromName() {
    if (length == 0) {
      return '';
    }

    final trimString = trim();
    if (trimString.isEmpty) {
      return '';
    }

    final parts = trimString.split(' ');
    // print('input: $this, parts: $parts, number of parts: ${parts.length}');
    // get fisrt and last part
    if (parts.isEmpty) {
      return '';
    } else if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    } else {
      return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
    }
  }
}

extension ColorEx on Color {
  Color darken({double amount = .1}) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  Color lighten({double amount = .1}) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}

extension StacktraceEx on StackTrace {
  List<String> getStackTrace({
    int maxFrames = 2,
    int ignoreFirstFrames = 0,
    bool removeAsyncSuspension = true,
  }) {
    assert(maxFrames > 0);
    assert(ignoreFirstFrames >= 0);

    final lines = toString()
        .split('\n')
        .where((element) =>
            !removeAsyncSuspension || element != '<asynchronous suspension>')
        .toList();
    if (lines.length <= maxFrames) {
      return lines;
    } else if (lines.length <= ignoreFirstFrames + maxFrames) {
      return lines.sublist(lines.length - maxFrames, lines.length);
    } else {
      return lines.sublist(ignoreFirstFrames, ignoreFirstFrames + maxFrames);
    }
  }
}
