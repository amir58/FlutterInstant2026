import 'package:navigations/core/api/api_result.dart';
import 'package:navigations/lo2ta/auth/domain/repositories/auth_repo.dart';

class ResetPasswordUseCase {
  ResetPasswordUseCase(this._repository);

  final AuthRepository _repository;

  Future<ApiResult<void>> call(String email) =>
      _repository.sendPasswordReset(email);
}
