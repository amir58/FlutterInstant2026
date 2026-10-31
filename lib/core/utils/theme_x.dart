import 'package:flutter/material.dart';

extension ThemeX on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get text => Theme.of(this).textTheme;
}

// وبعدها في أي ويدجت:
//   color: context.colors.primary
//   style: context.text.titleMedium