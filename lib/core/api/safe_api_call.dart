import 'package:navigations/core/api/api_result.dart';

import 'exceptions/failure_handler.dart';

Future<ApiResult<T>> safeApiCall<T>(Future<T> Function() call) async {
  try {
    final data = await call();
    return ApiSuccess(data);
  } catch (error) {
    return ApiFailure(ApiFailureHandler.handle(error));
  }
}