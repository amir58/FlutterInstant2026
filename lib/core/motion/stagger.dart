import 'package:flutter/animation.dart';

/// بيوزّع عناصر كتير على AnimationController واحد:
/// الأول بيبدأ بعد [delay]، وكل عنصر بعده بيتأخر [step]، وكل واحد بياخد [item].
class Stagger {
  const Stagger({
    required this.item,
    required this.step,
    required this.maxItems,
    this.delay = Duration.zero,
    this.curve = Curves.easeOutCubic,
  }) : assert(maxItems > 0);

  final Duration item;
  final Duration step;
  final Duration delay;

  /// بعد العدد ده، الباقي كله بيدخل مع آخر واحد — مش هنستنى 50 كارت
  final int maxItems;
  final Curve curve;

  /// المدة اللي الـ AnimationController محتاجها
  Duration get total => delay + step * (maxItems - 1) + item;

  Interval intervalFor(int index) {
    final slot = index.clamp(0, maxItems - 1);
    final totalMs = total.inMilliseconds;
    final begin = (delay + step * slot).inMilliseconds / totalMs;
    final end = begin + item.inMilliseconds / totalMs;
    // الكسور ممكن تطلّع 1.0000000002 — و Interval بيعمل assert لو عدّى 1
    return Interval(begin, end.clamp(0.0, 1.0), curve: curve);
  }
}