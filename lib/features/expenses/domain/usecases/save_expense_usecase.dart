import 'package:navigations/core/api/api_result.dart';
import 'package:navigations/core/database/db_failure.dart';
import 'package:navigations/features/expenses/domain/entities/expense.dart';
import 'package:navigations/features/expenses/domain/repos/expenses_repo.dart';

class SaveExpenseUseCase {
  SaveExpenseUseCase(this._repository, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final ExpensesRepository _repository;
  final DateTime Function()
  _now; // متحقونة عشان الاختبارات تبقى ثابتة

  static const int maxTitleLength = 60;

  Future<ApiResult<void>> call(ExpenseEntity expense) async {
    // final cleaned = expense.copyWith(title: expense.title.trim());

    final failure = _validate(expense);
    if (failure != null) return ApiFailure(failure);

    return expense.isNew
        ? _repository.addExpense(expense)
        : _repository.updateExpense(expense);
  }

  ValidationFailure? _validate(ExpenseEntity expense) {
    if (expense.title.isEmpty) {
      return const ValidationFailure('اكتب اسم المصروف');
    }
    if (expense.title.length > maxTitleLength) {
      return const ValidationFailure(
        'الاسم طويل — خليه أقل من ٦٠ حرف',
      );
    }
    if (expense.amountPiasters <= 0) {
      return const ValidationFailure('المبلغ لازم يكون أكبر من صفر');
    }
    if (expense.spentAt.isAfter(_now())) {
      return const ValidationFailure(
        'مينفعش تسجّل مصروف في المستقبل',
      );
    }
    return null;
  }
}
