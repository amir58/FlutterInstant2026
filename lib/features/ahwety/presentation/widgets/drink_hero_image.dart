import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../../domain/entities/drink.dart';

/// صورة المشروب في الكارت وفي التفاصيل — نفس الـ tag ونفس الشكل في مكان واحد
class DrinkHeroImage extends StatelessWidget {
  const DrinkHeroImage.card({super.key, required this.drink})
      : borderRadius = const BorderRadius.all(Radius.circular(14)),
        emojiSize = 52;

  const DrinkHeroImage.details({super.key, required this.drink})
      : borderRadius = const BorderRadius.vertical(bottom: Radius.circular(32)),
        emojiSize = 120;

  final Drink drink;
  final BorderRadius borderRadius;
  final double emojiSize;

  static String tagFor(int drinkId) => 'drink-image-$drinkId';

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tagFor(drink.id),
      flightShuttleBuilder: _flightShuttle,
      child: _DrinkArt(drink: drink, borderRadius: borderRadius, emojiSize: emojiSize),
    );
  }

  // اللي بيطير: الحواف وحجم الإيموجي بيتحوّلوا بالتدريج بدل ما يتنطّوا
  static Widget _flightShuttle(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection direction,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    final from = (fromHeroContext.widget as Hero).child as _DrinkArt;
    final to = (toHeroContext.widget as Hero).child as _DrinkArt;
    // الـ animation: 0 = شكل المنيو و 1 = شكل التفاصيل — في الـ push والـ pop
    final (menu, details) = switch (direction) {
      HeroFlightDirection.push => (from, to),
      HeroFlightDirection.pop => (to, from),
    };
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) => _DrinkArt(
        drink: details.drink,
        borderRadius: BorderRadius.lerp(menu.borderRadius, details.borderRadius, animation.value)!,
        emojiSize: lerpDouble(menu.emojiSize, details.emojiSize, animation.value)!,
      ),
    );
  }
}

class _DrinkArt extends StatelessWidget {
  const _DrinkArt({required this.drink, required this.borderRadius, required this.emojiSize});

  final Drink drink;
  final BorderRadius borderRadius;
  final double emojiSize;

  @override
  Widget build(BuildContext context) {
    // Material شفاف: وهو طاير في الـ Overlay مفيش Material فوقه،
    // ومن غيره الإيموجي (Text) هيطلع تحته خطين أصفر
    return Material(
      type: MaterialType.transparency,
      child: DecoratedBox(
        decoration: BoxDecoration(color: Color(drink.tintValue), borderRadius: borderRadius),
        child: Center(child: Text(drink.emoji, style: TextStyle(fontSize: emojiSize))),
      ),
    );
  }
}