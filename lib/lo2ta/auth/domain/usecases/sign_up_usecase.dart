import 'package:navigations/core/api/api_result.dart';
import 'package:navigations/core/api/exceptions/failure.dart';
import 'package:navigations/lo2ta/auth/domain/repositories/auth_repo.dart';

class SignUpUseCase {
  SignUpUseCase(this._repository);

  final AuthRepository _repository;

  Future<ApiResult<void>> call({
    required String name,
    required String email,
    required String password,
  }) async {
    final cleanName = name.trim();
    if (cleanName.length < 2) {
      return const ApiFailure(
        ValidationFailure('اكتب اسمك — حرفين على الأقل'),
      );
    }
    
    return _repository.signUp(
      name: cleanName,
      email: email.trim(),
      password: password,
    );
  }
}
