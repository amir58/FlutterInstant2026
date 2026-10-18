import 'package:get_it/get_it.dart';
import 'package:navigations/core/database/db.dart';
import 'package:navigations/features/expenses/data/datasources/expenses_local_data_source.dart';
import 'package:navigations/features/expenses/data/repositories/expenses_repository_impl.dart';
import 'package:navigations/features/expenses/domain/repos/expenses_repo.dart';
import 'package:navigations/features/expenses/domain/usecases/delete_expense_usecase.dart';
import 'package:navigations/features/expenses/domain/usecases/get_categories_usecase.dart';
import 'package:navigations/features/expenses/domain/usecases/get_month_overview_usecase.dart';
import 'package:navigations/features/expenses/domain/usecases/save_expense_usecase.dart';
import 'package:navigations/features/expenses/presentation/cubit/expenses_cubit.dart';
import 'package:navigations/features/expenses/presentation/cubit/form_cubit.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  // Core
  getIt.registerLazySingleton(() => DatabaseHelper());

  // Data
  getIt.registerLazySingleton<ExpensesLocalDataSource>(
    () => ExpensesLocalDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<ExpensesRepository>(
    () => ExpensesRepositoryImpl(getIt()),
  );

  // Domain
  getIt.registerLazySingleton(() => GetCategoriesUseCase(getIt()));
  getIt.registerLazySingleton(() => GetMonthOverviewUseCase(getIt()));
  getIt.registerLazySingleton(() => SaveExpenseUseCase(getIt()));
  getIt.registerLazySingleton(() => DeleteExpenseUseCase(getIt()));

  // Presenstion
  getIt.registerFactory(() => ExpensesCubit(getIt(), getIt()));
  getIt.registerFactory(() => ExpenseFormCubit(getIt(), getIt()));
}
