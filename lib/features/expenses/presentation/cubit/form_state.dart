sealed class ExpenseFormState {
  const ExpenseFormState();
}

class ExpenseFormIdle extends ExpenseFormState {
  const ExpenseFormIdle();
}

class ExpenseFormSubmitting extends ExpenseFormState {
  const ExpenseFormSubmitting();
}

class ExpenseFormDone extends ExpenseFormState {
  const ExpenseFormDone();
}

class ExpenseFormFailure extends ExpenseFormState {
  final String message;
  const ExpenseFormFailure(this.message);
}