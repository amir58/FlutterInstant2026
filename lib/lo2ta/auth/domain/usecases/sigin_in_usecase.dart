import 'package:navigations/core/api/api_result.dart';
import 'package:navigations/lo2ta/auth/domain/repositories/auth_repo.dart';

class SignInUseCase {
  SignInUseCase(this._repository);

  final AuthRepository _repository;

  Future<ApiResult<void>> call({
    required String email,
    required String password,
  }) => _repository.signIn(email: email.trim(), password: password);
}
