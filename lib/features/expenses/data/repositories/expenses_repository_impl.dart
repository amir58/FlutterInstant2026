import 'package:navigations/core/api/api_result.dart';
import 'package:navigations/core/database/db_failure.dart';
import 'package:navigations/core/database/db_safe_call.dart';
import 'package:navigations/features/expenses/data/datasources/expenses_local_data_source.dart';
import 'package:navigations/features/expenses/data/models/expense_model.dart';
import 'package:navigations/features/expenses/domain/entities/category_total.dart';
import 'package:navigations/features/expenses/domain/entities/expense.dart';
import 'package:navigations/features/expenses/domain/entities/expense_category.dart';
import 'package:navigations/features/expenses/domain/repos/expenses_repo.dart';

class ExpensesRepositoryImpl implements ExpensesRepository {
  final ExpensesLocalDataSource _local;
  const ExpensesRepositoryImpl(this._local);

  @override
  Future<ApiResult<List<ExpenseCategoryEntity>>> getCategories() {
    return safeDbCall(() async {
      final categories = await _local.getCategories();
      return categories.map((category) => category.toEntity()).toList();
    });
  }

  @override
  Future<ApiResult<List<ExpenseEntity>>> getMonthExpenses(
    DateTime month, {
    int? categoryId,
  }) {

    final range = _monthRange(month);

    return safeDbCall(() async {

      final models = await _local.getExpenses(
        from: range.from,
        to: range.to,
        categoryId: categoryId,
      );

      return models.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Future<ApiResult<List<CategoryTotalEntity>>> getMonthTotals(DateTime month) {
    final range = _monthRange(month);

    return safeDbCall(() async {
      final models = await _local.getTotals(from: range.from, to: range.to);
      return models.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Future<ApiResult<void>> addExpense(ExpenseEntity expense) {
    return safeDbCall(() => _local.insertExpense(ExpenseModel.fromEntity(expense)));
  }

  @override
  Future<ApiResult<void>> updateExpense(ExpenseEntity expense) async {
    final result = await safeDbCall(
      () => _local.updateExpense(ExpenseModel.fromEntity(expense)),
    );

    return _requireAffected(result);
  }

  @override
  Future<ApiResult<void>> deleteExpense(int id) async {
    final result = await safeDbCall(() => _local.deleteExpense(id));
    
    return _requireAffected(result);
  }

  // update و delete بيرجّعوا عدد الصفوف — صفر يعني المصروف مش موجود
  ApiResult<void> _requireAffected(ApiResult<int> result) {
    return switch (result) {
      ApiSuccess(data: 0) =>
        const ApiFailure(NotFoundFailure('المصروف ده مش موجود — يمكن اتمسح')),
      ApiSuccess() => const ApiSuccess(null),
      ApiFailure(:final failure) => ApiFailure(failure),
    };
  }

  // الشهر ⇐ range بالـ millis: من أول الشهر لحد أول الشهر اللي بعده
  ({int from, int to}) _monthRange(DateTime month) {
    return (
      from: DateTime(month.year, month.month).millisecondsSinceEpoch,
      to: DateTime(month.year, month.month + 1).millisecondsSinceEpoch,
    );
  }
}