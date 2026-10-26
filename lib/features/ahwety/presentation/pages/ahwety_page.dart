import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigations/core/motion/app_motion.dart';
import 'package:navigations/features/ahwety/domain/entities/drink.dart';
import 'package:navigations/features/ahwety/presentation/bloc/cart_cubit.dart';
import 'package:navigations/features/ahwety/presentation/bloc/menu_cubit.dart';
import 'package:navigations/features/ahwety/presentation/bloc/menu_state.dart';
import 'package:navigations/features/ahwety/presentation/pages/drink_details_page.dart';
import 'package:navigations/features/ahwety/presentation/widgets/cart_badge.dart';
import 'package:navigations/features/ahwety/presentation/widgets/cart_summary_bar.dart';
import 'package:navigations/features/ahwety/presentation/widgets/category_chips.dart';
import 'package:navigations/features/ahwety/presentation/widgets/staggered_menu_grid.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قهوتي'),
        actions: const [CartBadge()],
      ),
      body: const Stack(
        children: [
          Positioned.fill(child: _MenuBody()),
          PositionedDirectional(
            start: 0,
            end: 0,
            bottom: 0,
            child: CartSummaryBar(),
          ),
        ],
      ),
    );
  }
}

class _MenuBody extends StatelessWidget {
  const _MenuBody();

  @override
  Widget build(BuildContext context) {
    // بيعيد البناء لما «نوع» الحالة يتغير بس — التفاصيل جوّه BlocSelectors أصغر
    return BlocBuilder<MenuCubit, MenuState>(
      buildWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType,
      builder: (context, state) => AnimatedSwitcher(
        duration: AppMotion.medium,
        child: switch (state) {
          MenuLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          MenuError(:final message) => _MenuError(message: message),
          MenuLoaded() => const _MenuContent(),
        },
      ),
    );
  }
}

class _MenuContent extends StatelessWidget {
  const _MenuContent();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MenuCubit>();
    return Column(
      children: [
        BlocSelector<MenuCubit, MenuState, DrinkCategory?>(
          selector: (state) =>
              state is MenuLoaded ? state.category : null,
          builder: (context, category) => CategoryChips(
            selected: category,
            onSelected: cubit.selectCategory,
          ),
        ),
        Expanded(
          child: BlocSelector<MenuCubit, MenuState, List<Drink>>(
            selector: (state) =>
                state is MenuLoaded ? state.visible : const [],
            builder: (context, drinks) => StaggeredMenuGrid(
              drinks: drinks,
              onOpen: (drink) {
                Navigator.of(context).push(
                  DrinkDetailsPage.route(
                    drink,
                    context.read<MenuCartCubit>(),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _MenuError extends StatelessWidget {
  const _MenuError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: context.read<MenuCubit>().load,
            child: const Text('حاول تاني'),
          ),
        ],
      ),
    );
  }
}
