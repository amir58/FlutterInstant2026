import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigations/core/motion/app_motion.dart';
import 'package:navigations/core/widgets/animated_price.dart';
import 'package:navigations/features/ahwety/domain/entities/cart.dart';
import 'package:navigations/features/ahwety/presentation/bloc/cart_cubit.dart';

class CartSummaryBar extends StatelessWidget {
  const CartSummaryBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<MenuCartCubit, Cart>(
      builder: (context, cart) {
        final visible = !cart.isEmpty;
        // AnimatedSlide بيحرّك الرسم بس — الـ grid اللي ورا مبيتحركش
        return AnimatedSlide(
          duration: AppMotion.page,
          curve: visible ? AppMotion.enter : AppMotion.exit,
          offset: visible ? Offset.zero : const Offset(0, 1.5),
          child: SafeArea(
            minimum: const EdgeInsets.all(16),
            child: Material(
              color: colors.inverseSurface,
              elevation: 6,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Text(
                      '${cart.count} في السلة',
                      style: textTheme.titleSmall?.copyWith(
                        color: colors.onInverseSurface,
                      ),
                    ),
                    const Spacer(),
                    AnimatedPrice(
                      price: cart.total,
                      style: textTheme.titleMedium?.copyWith(
                        color: colors.onInverseSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
