import 'package:flutter/material.dart';
import 'package:navigations/core/motion/app_motion.dart';
import 'package:navigations/features/ahwety/domain/entities/drink.dart';

class CategoryChips extends StatelessWidget {
  const CategoryChips({super.key, required this.selected, required this.onSelected});

  final DrinkCategory? selected;
  final ValueChanged<DrinkCategory?> onSelected;

  static const _options = <(DrinkCategory?, String)>[
    (null, 'الكل'),
    (DrinkCategory.hot, 'سخن'),
    (DrinkCategory.iced, 'ساقع'),
    (DrinkCategory.dessert, 'حلو'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _options.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final (category, label) = _options[index];
          return _CategoryChip(
            label: label,
            selected: category == selected,
            onTap: () => onSelected(category),
          );
        },
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme.labelLarge!;
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppMotion.medium,
          curve: AppMotion.standard,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: selected ? 20 : 14),
          decoration: BoxDecoration(
            color: selected ? colors.primary : colors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(selected ? 12 : 20),
          ),
          child: AnimatedDefaultTextStyle(
            duration: AppMotion.medium,
            curve: AppMotion.standard,
            style: textStyle.copyWith(
              color: selected ? colors.onPrimary : colors.onSurfaceVariant,
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}