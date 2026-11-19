import 'dart:async';

import 'package:navigations/core/api/api_result.dart';
import 'package:navigations/core/crash/crash_report.dart';
import 'package:navigations/core/firebase/firebase_guard.dart';
import 'package:navigations/lo2ta/auth/data/datasources/auth_remote_data_source.dart';
import 'package:navigations/lo2ta/auth/domain/entities/app_user.dart';
import 'package:navigations/lo2ta/auth/domain/repositories/auth_repo.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote, this._guard, this._crash);

  final AuthRemoteDataSource _remote;
  final FirebaseGuard _guard;
  final CrashReporter _crash;

  @override
  Stream<AppUser?> watchUser() {
    return _remote.userChanges().map((user) {
      // أي كراش بعد كده هيتسجّل باسم المستخدم ده في Crashlytics
      unawaited(_crash.setUserId(user?.uid ?? ''));
      if (user == null) return null;
      return AppUser(
        id: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
      );
    });
  }

  @override
  Future<ApiResult<void>> signIn({
    required String email,
    required String password,
  }) =>
      _guard(() => _remote.signIn(email: email, password: password));

  @override
  Future<ApiResult<void>> signUp({
    required String name,
    required String email,
    required String password,
  }) => _guard(() {
    return _remote.signUp(
      name: name,
      email: email,
      password: password,
    );
  });

  @override
  Future<ApiResult<void>> signInWithGoogle() =>
      _guard(_remote.signInWithGoogle);

  @override
  Future<ApiResult<void>> sendPasswordReset(String email) =>
      _guard(() => _remote.sendPasswordReset(email));

  @override
  Future<ApiResult<void>> signOut() => _guard(_remote.signOut);
}
