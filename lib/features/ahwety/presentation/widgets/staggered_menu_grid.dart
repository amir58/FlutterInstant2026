import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:navigations/core/motion/fade_slide_in.dart';
import 'package:navigations/core/motion/stagger.dart';
import 'package:navigations/features/ahwety/presentation/widgets/drink_card.dart';

import '../../domain/entities/drink.dart';

class StaggeredMenuGrid extends StatefulWidget {
  const StaggeredMenuGrid({super.key, required this.drinks, required this.onOpen});

  final List<Drink> drinks;
  final ValueChanged<Drink> onOpen;

  @override
  State<StaggeredMenuGrid> createState() => _StaggeredMenuGridState();
}

class _StaggeredMenuGridState extends State<StaggeredMenuGrid>
    with SingleTickerProviderStateMixin {
  
  static const _stagger = Stagger(
    item: Duration(milliseconds: 420),
    step: Duration(milliseconds: 70),
    maxItems: 6,
  );

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _stagger.total)..forward();
  }

  @override
  void didUpdateWidget(covariant StaggeredMenuGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    // قسم جديد ⇐ الكروت تدخل تاني ورا بعض
    if (!listEquals(oldWidget.drinks, widget.drinks)) _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final drinks = widget.drinks;
    if (drinks.isEmpty) {
      return const Center(child: Text('مفيش حاجة في القسم ده لسه'));
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 112), // مساحة لشريط السلة
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.78,
      ),
      itemCount: drinks.length,
      itemBuilder: (context, index) {
        final drink = drinks[index];
        
        return FadeSlideIn(
          // drive مش CurvedAnimation: مبيسجّلش listener وإحنا جوّه build
          animation: _controller.drive(CurveTween(curve: _stagger.intervalFor(index))),
          child: DrinkCard(drink: drink, onTap: () => widget.onOpen(drink)),
        );
      },
    );
  }
}