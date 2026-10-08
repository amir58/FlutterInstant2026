import '../../domain/entities/expense.dart';
import 'category_model.dart';

class ExpenseModel {
  final int? id;
  final String title;
  final int amountPiasters;
  final CategoryModel category;
  final DateTime spentAt;
  final bool isRecurring;

  const ExpenseModel({
    this.id,
    required this.title,
    required this.amountPiasters,
    required this.category,
    required this.spentAt,
    this.isRecurring = false,
  });

  // الصف جاي من JOIN: أعمدة الفئة بأسماء مستعارة (AS)
  factory ExpenseModel.fromMap(Map<String, Object?> map) {
    return ExpenseModel(
      id: map['id'] as int,
      title: map['title'] as String,
      amountPiasters: map['amount_piasters'] as int,
      category: CategoryModel(
        id: map['category_id'] as int,
        name: map['category_name'] as String,
        colorValue: map['category_color'] as int,
      ),
      spentAt: DateTime.fromMillisecondsSinceEpoch(
        map['spent_at'] as int,
      ),
      isRecurring: (map['is_recurring'] as int) == 1,
    );
  }

  factory ExpenseModel.fromEntity(ExpenseEntity expense) {
    return ExpenseModel(
      id: expense.id,
      title: expense.title,
      amountPiasters: expense.amountPiasters,
      category: CategoryModel.fromEntity(expense.category),
      spentAt: expense.spentAt,
      isRecurring: expense.isRecurring,
    );
  }

  // للكتابة: الفئة بتتخزّن id بس
  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'amount_piasters': amountPiasters,
      'category_id': category.id,
      'spent_at': spentAt.millisecondsSinceEpoch,
      'is_recurring': isRecurring ? 1 : 0,
    };
  }

  ExpenseEntity toEntity() {
    return ExpenseEntity(
      id: id,
      title: title,
      amountPiasters: amountPiasters,
      category: category.toEntity(),
      spentAt: spentAt,
      isRecurring: isRecurring,
    );
  }
}
