import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigations/features/expenses/domain/entities/expense_category.dart';
import 'package:navigations/features/expenses/presentation/widgets/category_filter_bar.dart';
import 'package:navigations/features/expenses/presentation/widgets/expense_tile.dart';
import 'package:navigations/features/expenses/presentation/widgets/expnese_form_sheet.dart';
import 'package:navigations/features/expenses/presentation/widgets/month_header.dart';

import '../cubit/expenses_cubit.dart';
import '../cubit/expenses_state.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  @override
  void initState() {
    super.initState();
    context.read<ExpensesCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مصروفي')),
      floatingActionButton: const _AddExpenseButton(),
      body: const _ExpensesBody(),
    );
  }
}

class _ExpensesBody extends StatelessWidget {
  const _ExpensesBody();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExpensesCubit, ExpensesState>(
      listenWhen: (_, current) =>
          current is ExpensesLoaded && current.notice != null,
      listener: (context, state) {
        if (state case ExpensesLoaded(notice: final notice?)) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(notice)));
        }
      },
      builder: (context, state) => switch (state) {
        ExpensesLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
        ExpensesError(:final message) => _ErrorView(message: message),
        ExpensesLoaded loaded => _LoadedView(state: loaded),
      },
    );
  }
}

class _LoadedView extends StatelessWidget {
  const _LoadedView({required this.state});

  final ExpensesLoaded state;

  @override
  Widget build(BuildContext context) {
    final expenses = state.overview.expenses;
    
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: MonthHeader(overview: state.overview),
        ),
        SliverToBoxAdapter(
          child: CategoryFilterBar(
            categories: state.categories,
            selectedId: state.selectedCategoryId,
          ),
        ),
        if (expenses.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(
                'مفيش مصاريف هنا لسه — دوس + وضيف أول واحد',
              ),
            ),
          )
        else
          SliverList.builder(
            itemCount: expenses.length,
            itemBuilder: (context, i) => ExpenseTile(
              expense: expenses[i],
              onTap: () => openExpenseForm(
                context,
                categories: state.categories,
                expense: expenses[i],
              ),
            ),
          ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 88),
        ), // مساحة للـ FAB
      ],
    );
  }
}

class _AddExpenseButton extends StatelessWidget {
  const _AddExpenseButton();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      ExpensesCubit,
      ExpensesState,
      List<ExpenseCategoryEntity>
    >(
      selector: (state) => switch (state) {
        ExpensesLoaded(:final categories) => categories,
        _ => const [],
      },
      builder: (context, categories) {
        if (categories.isEmpty) return const SizedBox.shrink();
        return FloatingActionButton(
          onPressed: () =>
              openExpenseForm(context, categories: categories),
          child: const Icon(Icons.add),
        );
      },
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => context.read<ExpensesCubit>().load(),
            child: const Text('حاول تاني'),
          ),
        ],
      ),
    );
  }
}
