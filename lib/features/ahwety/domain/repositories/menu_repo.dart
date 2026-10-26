import 'package:navigations/core/api/api_result.dart';

import '../entities/drink.dart';

abstract class MenuRepository {
  Future<ApiResult<List<Drink>>> getMenu();
}