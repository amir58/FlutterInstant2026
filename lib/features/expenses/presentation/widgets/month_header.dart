import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigations/core/utils/money.dart';

import '../../domain/entities/category_total.dart';
import '../../domain/entities/month_overview.dart';
import '../cubit/expenses_cubit.dart';

class MonthHeader extends StatelessWidget {
  const MonthHeader({super.key, required this.overview});

  final MonthOverviewEntity overview;

  static const _months = [
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ExpensesCubit>();
    final month = overview.month;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                // Flutter بيعكس اتجاه الأسهم لوحده في RTL
                IconButton(
                  onPressed: () => cubit.changeMonth(-1),
                  icon: const Icon(Icons.chevron_left),
                ),
                Expanded(
                  child: Text(
                    '${_months[month.month - 1]} ${month.year}',
                    textAlign: TextAlign.center,
                    style: textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  onPressed: () => cubit.changeMonth(1),
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            Text(
              overview.grandTotalPiasters.egp(),
              textAlign: TextAlign.center,
              style: textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            for (final total in overview.totals)
              _CategoryBar(
                total: total,
                share: overview.shareOf(total),
              ),
          ],
        ),
      ),
    );
  }
}

class _CategoryBar extends StatelessWidget {
  const _CategoryBar({required this.total, required this.share});

  final CategoryTotalEntity total;
  final double share;

  @override
  Widget build(BuildContext context) {
    final color = Color(total.category.colorValue);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(total.category.name)),
          Expanded(
            child: LinearProgressIndicator(
              value: share,
              color: color,
              backgroundColor: color.withValues(alpha: 0.15),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Text(total.totalPiasters.egp()),
        ],
      ),
    );
  }
}
