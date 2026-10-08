import 'package:navigations/core/api/api_result.dart';

import '../entities/category_total.dart';
import '../entities/expense.dart';
import '../entities/expense_category.dart';

abstract class ExpensesRepository {
  Future<ApiResult<List<ExpenseCategoryEntity>>> getCategories();

  Future<ApiResult<List<ExpenseEntity>>> getMonthExpenses(
    DateTime month, {
    int? categoryId,
  });

  Future<ApiResult<List<CategoryTotalEntity>>> getMonthTotals(
    DateTime month,
  );

  Future<ApiResult<void>> addExpense(ExpenseEntity expense);

  Future<ApiResult<void>> updateExpense(ExpenseEntity expense);

  Future<ApiResult<void>> deleteExpense(int id);
}