import 'package:flutter/widgets.dart';

extension SizedBoxExtension on num {
  SizedBox get verticalSpace => SizedBox(height: toDouble());

  SizedBox get horizontalSpace => SizedBox(width: toDouble());
}
