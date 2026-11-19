import 'package:navigations/core/api/api_result.dart';
import 'package:navigations/lo2ta/auth/domain/entities/app_user.dart';

abstract class AuthRepository {
  /// null = مفيش حد داخل
  Stream<AppUser?> watchUser();

  Future<ApiResult<void>> signIn({
    required String email,
    required String password,
  });

  Future<ApiResult<void>> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<ApiResult<void>> signInWithGoogle();

  Future<ApiResult<void>> sendPasswordReset(String email);

  Future<ApiResult<void>> signOut();
}
