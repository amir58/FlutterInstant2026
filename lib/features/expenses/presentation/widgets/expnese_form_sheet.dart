import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigations/core/database/db.dart';
import 'package:navigations/core/utils/money.dart';
import 'package:navigations/features/expenses/data/datasources/expenses_local_data_source.dart';
import 'package:navigations/features/expenses/data/repositories/expenses_repository_impl.dart';
import 'package:navigations/features/expenses/domain/usecases/delete_expense_usecase.dart';
import 'package:navigations/features/expenses/domain/usecases/save_expense_usecase.dart';
import 'package:navigations/features/expenses/presentation/cubit/form_cubit.dart';
import 'package:navigations/features/expenses/presentation/cubit/form_state.dart';

import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_category.dart';
import '../cubit/expenses_cubit.dart';

Future<void> openExpenseForm(
  BuildContext context, {
  required List<ExpenseCategoryEntity> categories,
  ExpenseEntity? expense,
}) async {
  final changed = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,

    builder: (_) => BlocProvider(
      create: (context) => ExpenseFormCubit(
        SaveExpenseUseCase(
          ExpensesRepositoryImpl(
            ExpensesLocalDataSourceImpl(DatabaseHelper()),
          ),
        ),
        DeleteExpenseUseCase(
          ExpensesRepositoryImpl(
            ExpensesLocalDataSourceImpl(DatabaseHelper()),
          ),
        ),
      ),
      child: ExpenseFormSheet(
        categories: categories,
        expense: expense,
      ),
    ),
  );
  if (changed == true && context.mounted) {
    await context.read<ExpensesCubit>().refresh(); // تحديث صامت
  }
}

class ExpenseFormSheet extends StatefulWidget {
  const ExpenseFormSheet({
    super.key,
    required this.categories,
    this.expense,
  });

  final List<ExpenseCategoryEntity> categories;
  final ExpenseEntity? expense;

  @override
  State<ExpenseFormSheet> createState() => _ExpenseFormSheetState();
}

class _ExpenseFormSheetState extends State<ExpenseFormSheet> {
  late final TextEditingController _title;
  late final TextEditingController _amount;
  late ExpenseCategoryEntity _category;
  late DateTime _spentAt;
  late bool _isRecurring;

  @override
  void initState() {
    super.initState();
    final expense = widget.expense;
    _title = TextEditingController(text: expense?.title);
    _amount = TextEditingController(
      text: expense?.amountPiasters.asPounds(),
    );
    _category = expense?.category ?? widget.categories.first;
    _spentAt = expense?.spentAt ?? DateTime.now();
    _isRecurring = expense?.isRecurring ?? false;
  }

  @override
  void dispose() {
    _title.dispose();
    _amount.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _spentAt,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _spentAt = picked);
  }

  void _save() {
    context.read<ExpenseFormCubit>().save(
      ExpenseEntity(
        id: widget.expense?.id,
        title: _title.text,
        // نص مش رقم؟ صفر — والـ UseCase هيرفضه برسالة واضحة
        amountPiasters: parsePiasters(_amount.text),
        category: _category,
        spentAt: _spentAt,
        isRecurring: _isRecurring,
      ),
    );
  }

  int parsePiasters(String amount) {
    int amountInPounds = int.tryParse(amount) ?? 0;

    return amountInPounds * 100;
  }

  @override
  Widget build(BuildContext context) {
    final id = widget.expense?.id;
    return BlocListener<ExpenseFormCubit, ExpenseFormState>(
      listener: (context, state) {
        if (state is ExpenseFormDone) Navigator.of(context).pop(true);
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          16 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              id == null ? 'مصروف جديد' : 'تعديل مصروف',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextField(
              controller: _title,
              decoration: const InputDecoration(
                labelText: 'اسمه إيه؟',
              ),
            ),
            TextField(
              controller: _amount,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'المبلغ',
                suffixText: 'ج.م',
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                for (final category in widget.categories)
                  ChoiceChip(
                    label: Text(category.name),
                    selected: category.id == _category.id,
                    onSelected: (_) =>
                        setState(() => _category = category),
                  ),
              ],
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('مصروف شهري ثابت'),
              value: _isRecurring,
              onChanged: (value) =>
                  setState(() => _isRecurring = value),
            ),
            TextButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.event),
              label: Text(
                '${_spentAt.day}/${_spentAt.month}/${_spentAt.year}',
              ),
            ),
            const _FormError(),
            const SizedBox(height: 8),
            _FormActions(
              onSave: _save,
              onDelete: id == null
                  ? null
                  : () => context.read<ExpenseFormCubit>().delete(id),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormError extends StatelessWidget {
  const _FormError();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ExpenseFormCubit, ExpenseFormState, String?>(
      selector: (state) =>
          state is ExpenseFormFailure ? state.message : null,
      builder: (context, message) {
        if (message == null) return const SizedBox.shrink();
        return Text(
          message,
          style: TextStyle(
            color: Theme.of(context).colorScheme.error,
          ),
        );
      },
    );
  }
}

class _FormActions extends StatelessWidget {
  const _FormActions({required this.onSave, this.onDelete});

  final VoidCallback onSave;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ExpenseFormCubit, ExpenseFormState, bool>(
      selector: (state) => state is ExpenseFormSubmitting,
      builder: (context, isSubmitting) {
        return Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: isSubmitting ? null : onSave,
                child: const Text('حفظ'),
              ),
            ),
            if (onDelete != null) ...[
              const SizedBox(width: 8),
              TextButton(
                onPressed: isSubmitting ? null : onDelete,
                child: const Text('مسح'),
              ),
            ],
          ],
        );
      },
    );
  }
}
