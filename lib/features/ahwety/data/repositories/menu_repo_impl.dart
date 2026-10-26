import 'dart:developer';

import 'package:navigations/core/api/api_result.dart';
import 'package:navigations/core/api/exceptions/failure.dart';
import 'package:navigations/features/ahwety/data/datasources/menu_local_data_source.dart';
import 'package:navigations/features/ahwety/domain/entities/drink.dart';
import 'package:navigations/features/ahwety/domain/repositories/menu_repo.dart';

class MenuRepositoryImpl implements MenuRepository {
  const MenuRepositoryImpl(this._dataSource);
  final MenuLocalDataSource _dataSource;

  @override
  Future<ApiResult<List<Drink>>> getMenu() async {
    try {
      final models = await _dataSource.getMenu();
      
      return ApiSuccess(
        models
            .map((model) => model.toEntity())
            .toList(growable: false),
      );

    } on FormatException catch (error, stackTrace) {
      log(
        'menu.json is invalid',
        name: 'menu',
        error: error,
        stackTrace: stackTrace,
      );
      return const ApiFailure(DataFormatFailure('DataFormatFailure'));
      
    } catch (error, stackTrace) {
      log(
        'could not load the menu',
        name: 'menu',
        error: error,
        stackTrace: stackTrace,
      );
      return const ApiFailure(UnknownFailure('UnknownFailure'));
    }
  }
}
