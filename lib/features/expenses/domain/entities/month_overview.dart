import 'category_total.dart';
import 'expense.dart';

class MonthOverviewEntity {
  final DateTime month;
  final List<ExpenseEntity> expenses;
  final List<CategoryTotalEntity> totals;

  const MonthOverviewEntity({
    required this.month,
    required this.expenses,
    required this.totals,
  });

  // جمع int — مظبوط بالقرش دايماً
  int get grandTotalPiasters =>
      totals.fold(0, (sum, total) => sum + total.totalPiasters);

  double shareOf(CategoryTotalEntity total) {
    final grand = grandTotalPiasters;
    return grand == 0 ? 0.0 : total.totalPiasters / grand;
  }
}
