import 'package:flutter/material.dart';

// كلاس مش هنعمل منه object — مجرد مكان نلم فيه الثيم
abstract final class AppTheme {
  static const seed =
      Colors.blueAccent; // ← لون البراند: مكتوب هنا بس

  static final ThemeData light = _build(Brightness.light);
  static final ThemeData dark = _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final colors = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
    );

    return ThemeData(
      colorScheme: colors,
      fontFamily: 'Cairo',

      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          // borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: colors.outlineVariant,
          ), // ← دور، مش لون
        ),
      ),
    );
  }
}
