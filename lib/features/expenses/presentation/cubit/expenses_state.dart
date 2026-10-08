import '../../domain/entities/expense_category.dart';
import '../../domain/entities/month_overview.dart';

sealed class ExpensesState {
  const ExpensesState();
}

class ExpensesLoading extends ExpensesState {
  const ExpensesLoading();
}

class ExpensesLoaded extends ExpensesState {
  final List<ExpenseCategoryEntity> categories;
  final MonthOverviewEntity overview;
  final int? selectedCategoryId;
  final String? notice; // رسالة لمرة واحدة — بتظهر SnackBar

  const ExpensesLoaded({
    required this.categories,
    required this.overview,
    this.selectedCategoryId,
    this.notice,
  });

  ExpensesLoaded withNotice(String message) {
    return ExpensesLoaded(
      categories: categories,
      overview: overview,
      selectedCategoryId: selectedCategoryId,
      notice: message,
    );
  }
}

class ExpensesError extends ExpensesState {
  final String message;
  const ExpensesError(this.message);
}
