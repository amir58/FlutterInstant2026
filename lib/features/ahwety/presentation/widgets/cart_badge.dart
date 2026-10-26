import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigations/core/motion/app_motion.dart';
import 'package:navigations/features/ahwety/presentation/bloc/cart_cubit.dart';

import '../../domain/entities/cart.dart';

class CartBadge extends StatelessWidget {
  const CartBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MenuCartCubit, Cart, int>(
      selector: (cart) => cart.count,
      builder: (context, count) => Padding(
        padding: const EdgeInsetsDirectional.only(end: 16),
        child: Badge(
          isLabelVisible: count > 0,
          label: AnimatedSwitcher(
            duration: AppMotion.fast,
            switchInCurve: AppMotion.pop,
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
                
            child: Text('$count', key: ValueKey(count)),
          ),
          child: const Icon(Icons.shopping_bag_outlined),
        ),
      ),
    );
  }
}
