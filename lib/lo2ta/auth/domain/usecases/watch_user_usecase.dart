import 'package:navigations/lo2ta/auth/domain/entities/app_user.dart';
import 'package:navigations/lo2ta/auth/domain/repositories/auth_repo.dart';

class WatchUserUseCase {
  WatchUserUseCase(this._repository);

  final AuthRepository _repository;

  Stream<AppUser?> call() => _repository.watchUser();
}