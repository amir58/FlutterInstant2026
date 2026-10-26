import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigations/core/motion/app_motion.dart';
import 'package:navigations/core/motion/fade_slide_in.dart';
import 'package:navigations/core/motion/stagger.dart';
import 'package:navigations/core/widgets/animated_price.dart';
import 'package:navigations/features/ahwety/presentation/bloc/cart_cubit.dart';
import 'package:navigations/features/ahwety/presentation/widgets/add_to_cart.dart';
import 'package:navigations/features/ahwety/presentation/widgets/cart_badge.dart';
import 'package:navigations/features/ahwety/presentation/widgets/size_selector.dart';

import '../../domain/entities/drink.dart';
import '../widgets/drink_hero_image.dart';

class DrinkDetailsPage extends StatefulWidget {
  const DrinkDetailsPage({super.key, required this.drink});

  final Drink drink;

  static Route<void> route(Drink drink, MenuCartCubit menuCartCubit) {
    return PageRouteBuilder<void>(
      transitionDuration: Duration(
        milliseconds: 400,
      ), // الـ Hero بيطير في نفس المدة

      reverseTransitionDuration: Duration(milliseconds: 400),

      pageBuilder: (context, animation, secondaryAnimation) =>
          BlocProvider.value(
            value: menuCartCubit,
            child: DrinkDetailsPage(drink: drink),
          ),

      // fade بسيط — والـ Hero هو اللي عامل الشو
      transitionsBuilder:
          (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
    );
  }

  @override
  State<DrinkDetailsPage> createState() => _DrinkDetailsPageState();
}

class _DrinkDetailsPageState extends State<DrinkDetailsPage>
    with SingleTickerProviderStateMixin {
  // المحتوى بيبدأ بعد ما الصورة تقرّب توصل (الـ Hero واخد 400ms)
  static const _stagger = Stagger(
    delay: Duration(milliseconds: 250),
    item: Duration(milliseconds: 450),
    step: Duration(milliseconds: 80),
    maxItems: 3,
  );

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _stagger.total,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Animation<double> _part(int index) => _controller.drive(
    CurveTween(curve: _stagger.intervalFor(index)),
  );

  @override
  Widget build(BuildContext context) {
    final drink = widget.drink;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: const [
          CartBadge(),
        ], // نفس العدّاد — CartCubit فوق الـ MaterialApp
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 300,
            child: DrinkHeroImage.details(drink: drink),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeSlideIn(
                  animation: _part(0),
                  child: Text(
                    drink.name,
                    style: textTheme.headlineSmall,
                  ),
                ),
                const SizedBox(height: 8),
                FadeSlideIn(
                  animation: _part(1),
                  child: Text(
                    drink.description,
                    style: textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(height: 24),
                FadeSlideIn(
                  animation: _part(2),
                  child: _OrderSection(drink: drink),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// الحجم حالة UI محلية — setState هنا بيعيد بناء الجزء ده بس
class _OrderSection extends StatefulWidget {
  const _OrderSection({required this.drink});

  final Drink drink;

  @override
  State<_OrderSection> createState() => _OrderSectionState();
}

class _OrderSectionState extends State<_OrderSection> {
  DrinkSize _size = DrinkSize.small;

  @override
  Widget build(BuildContext context) {
    final drink = widget.drink;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            if (drink.hasSizes) ...[
              SizeSelector(
                selected: _size,
                onChanged: (size) => setState(() => _size = size),
              ),
              const SizedBox(width: 12),
              AnimatedScale(
                scale: switch (_size) {
                  DrinkSize.small => 0.8,
                  DrinkSize.medium => 1.0,
                  DrinkSize.large => 1.2,
                },
                duration: AppMotion.medium,
                curve: AppMotion.pop,
                child: const Icon(
                  Icons.local_cafe_outlined,
                  size: 32,
                ),
              ),
            ],
            const Spacer(),
            AnimatedPrice(
              price: drink.priceFor(_size),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
        const SizedBox(height: 20),
        AddToCartButton(
          onAdd: () =>
              context.read<MenuCartCubit>().add(drink, _size),
        ),
      ],
    );
  }
}
