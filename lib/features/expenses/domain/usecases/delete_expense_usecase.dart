

import 'package:navigations/core/api/api_result.dart';
import 'package:navigations/features/expenses/domain/repos/expenses_repo.dart';

class DeleteExpenseUseCase {
  final ExpensesRepository _repository;
  
  const DeleteExpenseUseCase(this._repository);

  Future<ApiResult<void>> call(int id) => _repository.deleteExpense(id);
}