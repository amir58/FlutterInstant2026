import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:navigations/core/crash/crash_report.dart';
import 'package:navigations/core/database/db.dart';
import 'package:navigations/core/firebase/firebase_guard.dart';
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
import 'package:navigations/lo2ta/auth/data/datasources/auth_remote_data_source.dart';
import 'package:navigations/lo2ta/auth/data/repositories/auth_repo_impl.dart';
import 'package:navigations/lo2ta/auth/domain/repositories/auth_repo.dart';
import 'package:navigations/lo2ta/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:navigations/lo2ta/auth/domain/usecases/reset_password_usecase.dart';
import 'package:navigations/lo2ta/auth/domain/usecases/sigin_in_usecase.dart';
import 'package:navigations/lo2ta/auth/domain/usecases/sign_up_usecase.dart';
import 'package:navigations/lo2ta/auth/domain/usecases/signout_usecase.dart';
import 'package:navigations/lo2ta/auth/domain/usecases/watch_user_usecase.dart';
import 'package:navigations/lo2ta/auth/presentation/cubit/auth_cubit.dart';
import 'package:navigations/lo2ta/auth/presentation/cubit/sign_in_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // Core
  getIt.registerLazySingleton(() => DatabaseHelper());

  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => prefs);

  _setupExpenses();
  _setupAhwety();

  _setupLo2taCore();
  _setupLo2taSignIn();
  _setupLo2taAuth();
}

void _setupLo2taCore() {
  getIt.registerLazySingleton(() => FirebaseAuth.instance);

  getIt.registerLazySingleton(() => FirebaseFirestore.instance);

  getIt.registerLazySingleton(() => FirebaseCrashlytics.instance);

  getIt.registerLazySingleton(() => GoogleSignIn.instance);

  getIt.registerLazySingleton<CrashReporter>(
    () => CrashlyticsReporter(getIt()),
  );

  getIt.registerLazySingleton(() => FirebaseGuard(getIt()));
}

void _setupLo2taSignIn() {
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt(), getIt(), getIt()),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt(), getIt(), getIt()),
  );

  getIt.registerLazySingleton(() => SignInUseCase(getIt()));

  getIt.registerLazySingleton(() => SignUpUseCase(getIt()));

  getIt.registerLazySingleton(() => GoogleSignInUseCase(getIt()));

  getIt.registerLazySingleton(() => ResetPasswordUseCase(getIt()));

  getIt.registerFactory(
    () => SignInCubit(getIt(), getIt(), getIt(), getIt()),
  );
}

void _setupLo2taAuth() {
  getIt.registerLazySingleton(() => WatchUserUseCase(getIt()));

  getIt.registerLazySingleton(() => SignOutUseCase(getIt()));

  getIt.registerFactory(() => AuthCubit(getIt(), getIt()));
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
