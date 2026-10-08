import 'package:navigations/core/api/api_result.dart';
import 'package:navigations/features/expenses/domain/entities/expense_category.dart';
import 'package:navigations/features/expenses/domain/repos/expenses_repo.dart';

class GetCategoriesUseCase {
  final ExpensesRepository _repository;

  const GetCategoriesUseCase(this._repository);

  Future<ApiResult<List<ExpenseCategoryEntity>>> call() =>
      _repository.getCategories();
}
