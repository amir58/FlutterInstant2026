import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/expense_category.dart';
import '../cubit/expenses_cubit.dart';

class CategoryFilterBar extends StatelessWidget {
  const CategoryFilterBar({
    super.key,
    required this.categories,
    required this.selectedId,
  });

  final List<ExpenseCategoryEntity> categories;
  final int? selectedId;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ExpensesCubit>();
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _FilterChip(
            label: 'الكل',
            selected: selectedId == null,
            onSelected: () => cubit.selectCategory(null),
          ),
          for (final category in categories)
            _FilterChip(
              label: category.name,
              color: Color(category.colorValue),
              selected: selectedId == category.id,
              onSelected: () => cubit.selectCategory(category.id),
            ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    this.color,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        selectedColor: color?.withValues(alpha: 0.25),
        onSelected: (_) => onSelected(),
      ),
    );
  }
}