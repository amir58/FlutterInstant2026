import 'package:navigations/core/api/api_result.dart';
import 'package:navigations/features/expenses/domain/entities/month_overview.dart';
import 'package:navigations/features/expenses/domain/repos/expenses_repo.dart';

class GetMonthOverviewUseCase {
  final ExpensesRepository _repository;

  const GetMonthOverviewUseCase(this._repository);

  Future<ApiResult<MonthOverviewEntity>> call(
    DateTime month, {
    int? categoryId,
  }) async {
    final expensesResult = await _repository.getMonthExpenses(
      month,
      categoryId: categoryId,
    );

    final totalsResult = await _repository.getMonthTotals(month);

    return switch ((expensesResult, totalsResult)) {
      (
        ApiSuccess(data: final expenses),
        ApiSuccess(data: final totals),
      ) =>
        ApiSuccess(
          MonthOverviewEntity(
            month: month,
            expenses: expenses,
            totals: totals,
          ),
        ),

      (ApiFailure(:final failure), _) ||
      (_, ApiFailure(:final failure)) => ApiFailure(failure),
    };
  }
}
