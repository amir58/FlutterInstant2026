import 'package:flutter/widgets.dart';

/// Fade + Slide على نفس الـ animation — للكروت ولمحتوى التفاصيل
class FadeSlideIn extends StatelessWidget {
  const FadeSlideIn({
    super.key,
    required this.animation,
    required this.child,
    this.from = const Offset(0, 0.2),
  });

  final Animation<double> animation;
  final Offset from; // بنسبة من حجم الويدجت نفسه: 0.2 = خُمس ارتفاعه لتحت
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: animation.drive(Tween(begin: from, end: Offset.zero)),
        child: child,
      ),
    );
  }
}