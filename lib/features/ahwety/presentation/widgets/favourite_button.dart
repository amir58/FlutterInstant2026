import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigations/core/motion/app_motion.dart';
import 'package:navigations/features/ahwety/presentation/bloc/menu_cubit.dart';
import 'package:navigations/features/ahwety/presentation/bloc/menu_state.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key, required this.drinkId});

  final int drinkId;

  @override
  Widget build(BuildContext context) {
    // بيعيد البناء للزرار ده بس لما «المفضّل» بتاعه هو يتغير
    return BlocSelector<MenuCubit, MenuState, bool>(
      selector: (state) =>
          state is MenuLoaded && state.favoriteIds.contains(drinkId),
      builder: (context, isFavorite) => IconButton.filledTonal(
        // highlightColor: Colors.transparent,
        tooltip: isFavorite ? 'شيل من المفضّلة' : 'ضيف للمفضّلة',
        onPressed: () =>
            context.read<MenuCubit>().toggleFavorite(drinkId),
        icon: AnimatedSwitcher(
          duration: AppMotion.fast,
          switchInCurve:
              AppMotion.pop, // الداخل بينطّ — الخارج linear
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            key: ValueKey(isFavorite),
            color: isFavorite ? Colors.redAccent : null,
          ),
        ),
      ),
    );
  }
}
