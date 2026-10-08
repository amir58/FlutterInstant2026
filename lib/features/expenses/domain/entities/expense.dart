import 'expense_category.dart';

class ExpenseEntity {
  final int? id; // null = مصروف جديد لسه متحفظش
  final String title;
  final int amountPiasters;
  final ExpenseCategoryEntity category;
  final DateTime spentAt;
  final bool isRecurring;

  const ExpenseEntity({
    this.id,
    required this.title,
    required this.amountPiasters,
    required this.category,
    required this.spentAt,
    this.isRecurring = false,
  });

  bool get isNew => id == null;

  ExpenseEntity copyWith({
    String? title,
    int? amountPiasters,
    ExpenseCategoryEntity? category,
    DateTime? spentAt,
    bool? isRecurring,
  }) {
    return ExpenseEntity(
      id: id,
      title: title ?? this.title,
      amountPiasters: amountPiasters ?? this.amountPiasters,
      category: category ?? this.category,
      spentAt: spentAt ?? this.spentAt,
      isRecurring: isRecurring ?? this.isRecurring,
    );
  }
}
