import 'package:flutter/material.dart';

import 'package:navigations/core/motion/app_motion.dart';
import 'package:navigations/core/utils/price_format.dart';

/// رقم بيعدّ لحد السعر الجديد بدل ما يتنطّ
class AnimatedPrice extends StatelessWidget {
  const AnimatedPrice({super.key, required this.price, this.style});

  final int price;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      // الـ begin بيتاخد أول مرة بس — بعد كده بيكمّل من الرقم اللي ظاهر
      tween: IntTween(begin: price, end: price),
      duration: AppMotion.medium,
      curve: AppMotion.standard,
      builder: (context, value, _) => Text(value.egp, style: style),
    );
  }
}