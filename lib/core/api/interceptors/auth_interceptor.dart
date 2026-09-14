import 'package:dio/dio.dart';
import 'package:navigations/core/api/endpoints.dart';
import 'package:navigations/features/login/data/data_sources/token_local_datasource.dart';

class AuthInterceptor extends Interceptor {
  final TokenLocalDataSource _tokenStorage;

  AuthInterceptor(this._tokenStorage);

  // المسارات دي مش محتاجة توكن
  static const _publicPaths = [EndPoints.login];

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_publicPaths.contains(options.path)) {
      return handler.next(options);
    }

    final token = await _tokenStorage.accessToken;
    
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options); // ⚠️ من غير السطر ده الطلب هيقف هنا للأبد
  }
}
