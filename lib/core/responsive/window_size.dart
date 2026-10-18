import 'package:flutter/widgets.dart';

enum WindowSize {
  compact, // < 600
  medium, // 600 – 839
  expanded; // 840+

  static WindowSize fromWidth(double width) {
    if (width < 600) return WindowSize.compact;
    if (width < 840) return WindowSize.medium;
    return WindowSize.expanded;
  }
}

extension WindowSizeX on BuildContext {
  WindowSize get windowSize =>
      WindowSize.fromWidth(MediaQuery.sizeOf(this).width);

  bool get isCompactWindow => windowSize == WindowSize.compact;

  bool get isMediumWindow => windowSize == WindowSize.medium;

  bool get isExpandedWindow => windowSize == WindowSize.expanded;
}
