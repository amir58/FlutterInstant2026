import 'package:flutter/material.dart';
import 'package:navigations/core/motion/app_motion.dart';


import '../../domain/entities/drink.dart';

class SizeSelector extends StatelessWidget {
  const SizeSelector({super.key, required this.selected, required this.onChanged});

  final DrinkSize selected;
  final ValueChanged<DrinkSize> onChanged;

  static const double _itemWidth = 52;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    const sizes = DrinkSize.values;
    // -1 = أول الصف (اليمين في العربي) و 1 = آخره
    final x = -1 + 2 * selected.index / (sizes.length - 1);
    return Container(
      width: _itemWidth * sizes.length + 8,
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          // المؤشر بيتزحلق ورا الحروف
          AnimatedAlign(
            duration: AppMotion.medium,
            curve: AppMotion.standard,
            alignment: AlignmentDirectional(x, 0),
            child: Container(
              width: _itemWidth,
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Row(
            children: [
              for (final size in sizes)
                _SizeOption(
                  size: size,
                  selected: size == selected,
                  onTap: () => onChanged(size),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SizeOption extends StatelessWidget {
  const _SizeOption({required this.size, required this.selected, required this.onTap});

  final DrinkSize size;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final label = switch (size) {
      DrinkSize.small => 'S',
      DrinkSize.medium => 'M',
      DrinkSize.large => 'L',
    };
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          width: SizeSelector._itemWidth,
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: AppMotion.medium,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: selected ? colors.onPrimary : colors.onSurfaceVariant,
                  ),
              child: Text(label),
            ),
          ),
        ),
      ),
    );
  }
}