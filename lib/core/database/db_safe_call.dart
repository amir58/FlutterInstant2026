import 'dart:developer';

import 'package:navigations/core/api/api_result.dart';

import 'db_error_handler.dart';

Future<ApiResult<T>> safeDbCall<T>(Future<T> Function() call) async {
  try {
    return ApiSuccess(await call());
  } catch (error, stackTrace) {
    log(
      'DB call failed',
      name: 'db',
      error: error,
      stackTrace: stackTrace,
    );
    return ApiFailure(DatabaseErrorHandler.handle(error));
  }
}
