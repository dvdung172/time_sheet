import 'package:hsc_timesheet/core/theme.dart';
import 'package:flutter/material.dart';

class AppStyles {
  static TextStyle tableHeaderStyle =
      const TextStyle(fontWeight: FontWeight.bold);
  static TextStyle messageStyle =
      const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold);

  static ButtonStyle buttonStyle = ButtonStyle(
    foregroundColor: MaterialStateProperty.all<Color>(CustomColor.logoBlue),
    overlayColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.hovered)) {
          return CustomColor.logoBlue.withOpacity(0.04);
        }
        if (states.contains(MaterialState.focused) ||
            states.contains(MaterialState.pressed)) {
          return CustomColor.logoBlue.withOpacity(0.12);
        }
        return CustomColor.logoBlue;
      },
    ),
  );
}
