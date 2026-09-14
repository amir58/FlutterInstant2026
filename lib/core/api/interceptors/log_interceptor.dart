import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    debugPrint('➜ ${options.method} ${options.uri}');
    if (options.data != null) debugPrint('  body: ${options.data}');
    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    debugPrint(response.requestOptions.baseUrl);
    debugPrint(
      '✔ ${response.statusCode} - ${response.requestOptions.method} - ${response.requestOptions.path} -',
    );
    debugPrint('Response\n${response.data}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint(
      '✘ ${err.response?.statusCode} ${err.requestOptions.uri}',
    );
    handler.next(err);
  }
}
