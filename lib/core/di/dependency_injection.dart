import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:navigations/core/database/db.dart';
import 'package:navigations/features/ahwety/data/datasources/menu_local_data_source.dart';
import 'package:navigations/features/ahwety/data/repositories/menu_repo_impl.dart';
import 'package:navigations/features/ahwety/domain/repositories/menu_repo.dart';
import 'package:navigations/features/ahwety/domain/usecases/get_menu_use_case.dart';
import 'package:navigations/features/ahwety/presentation/bloc/cart_cubit.dart';
import 'package:navigations/features/ahwety/presentation/bloc/menu_cubit.dart';
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

  _setupExpenses();
  _setupAhwety();
}

void _setupExpenses() {
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

void _setupAhwety() {
  getIt.registerLazySingleton<MenuLocalDataSource>(
    () => MenuLocalDataSourceImpl(rootBundle),
  );

  getIt.registerLazySingleton<MenuRepository>(
    () => MenuRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton(() => GetMenuUseCase(getIt()));

  getIt.registerFactory(() => MenuCubit(getIt()));

  getIt.registerFactory(() => MenuCartCubit());
}
