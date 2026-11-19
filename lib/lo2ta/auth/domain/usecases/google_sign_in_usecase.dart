import 'package:navigations/core/api/api_result.dart';
import 'package:navigations/lo2ta/auth/domain/repositories/auth_repo.dart';

class GoogleSignInUseCase {
  GoogleSignInUseCase(this._repository);

  final AuthRepository _repository;

  Future<ApiResult<void>> call() => _repository.signInWithGoogle();
}
