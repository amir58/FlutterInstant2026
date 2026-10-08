import 'expense_category.dart';

class CategoryTotalEntity {
  final ExpenseCategoryEntity category;
  final int totalPiasters;

  const CategoryTotalEntity({
    required this.category,
    required this.totalPiasters,
  });
}
