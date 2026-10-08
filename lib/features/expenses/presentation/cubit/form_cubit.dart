import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigations/core/api/api_result.dart';
import 'package:navigations/features/expenses/domain/entities/expense.dart';
import 'package:navigations/features/expenses/domain/usecases/delete_expense_usecase.dart';
import 'package:navigations/features/expenses/domain/usecases/save_expense_usecase.dart';
import 'package:navigations/features/expenses/presentation/cubit/form_state.dart';

class ExpenseFormCubit extends Cubit<ExpenseFormState> {
  ExpenseFormCubit(this._saveExpense, this._deleteExpense)
    : super(const ExpenseFormIdle());

  final SaveExpenseUseCase _saveExpense;
  final DeleteExpenseUseCase _deleteExpense;

  Future<void> save(ExpenseEntity expense) =>
      _submit(() => _saveExpense(expense));

  Future<void> delete(int id) => _submit(() => _deleteExpense(id));

  Future<void> _submit(
    Future<ApiResult<void>> Function() action,
  ) async {
    if (state is ExpenseFormSubmitting) {
      return; // ضغطة مزدوجة؟ تجاهلها
    }

    emit(const ExpenseFormSubmitting());
    final result = await action();

    if (isClosed) return;

    emit(switch (result) {
      ApiSuccess() => const ExpenseFormDone(),
      ApiFailure(:final failure) => ExpenseFormFailure(
        failure.message,
      ),
    });
  }
}
