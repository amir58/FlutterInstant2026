import 'package:navigations/core/api/api_result.dart';
import 'package:navigations/features/ahwety/domain/entities/drink.dart';
import 'package:navigations/features/ahwety/domain/repositories/menu_repo.dart';

class GetMenuUseCase {
  const GetMenuUseCase(this._repository);
  final MenuRepository _repository;

  Future<ApiResult<List<Drink>>> call() => _repository.getMenu();
}