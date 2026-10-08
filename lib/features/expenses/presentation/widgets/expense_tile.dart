import 'package:flutter/material.dart';

import 'package:navigations/core/utils/money.dart';

import '../../domain/entities/expense.dart';

class ExpenseTile extends StatelessWidget {
  const ExpenseTile({
    super.key,
    required this.expense,
    required this.onTap,
  });

  final ExpenseEntity expense;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(expense.category.colorValue);
    final date = expense.spentAt;
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.2),
        foregroundColor: color,
        child: const Icon(Icons.receipt_long),
      ),
      title: Text(expense.title),
      subtitle: Text(
        [
          expense.category.name,
          '${date.day}/${date.month}',
          if (expense.isRecurring) 'شهري',
        ].join(' · '),
      ),
      trailing: Text(
        expense.amountPiasters.egp(),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
