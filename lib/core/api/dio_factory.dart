import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:navigations/core/api/endpoints.dart';
import 'package:navigations/core/api/interceptors/auth_interceptor.dart';
import 'package:navigations/features/login/data/data_sources/token_local_datasource.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

// Design Pattern => Singleton
class DioFactory {
  DioFactory._();

  static Dio? _dio;

  static Dio getDio() {
    if (_dio == null) {
      _dio = Dio(
        BaseOptions(
          baseUrl: EndPoints.baseUrl,
          connectTimeout: const Duration(
            seconds: 20,
          ), // مدة فتح الاتصال
          receiveTimeout: const Duration(
            seconds: 20,
          ), // مدة استقبال الرد
          sendTimeout: const Duration(
            seconds: 20,
          ), // مدة إرسال الداتا
          headers: const {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Accept-Language': 'en',
          },
          responseType: ResponseType.json,
        ),
      );

      _dio!.interceptors.add(
        AuthInterceptor(TokenLocalDataSource(FlutterSecureStorage())),
      );

      _dio!.interceptors.add(
        PrettyDioLogger(
          requestBody: true,
          requestHeader: true,
          enabled: kDebugMode,
          responseBody: true,
        ),
      );

      // if (kDebugMode) {
      //   _dio!.interceptors.add(LoggerInterceptor());
      // }
    }

    // الـ interceptors هنضيفها في الموضوع ٩
    return _dio!;
  }
}

// _dio = Dio() => new hashcode
// _dio = Dio() => new hashcode
// _dio = Dio() => new hashcode
// _dio = Dio() => new hashcode
// _dio = Dio() => new hashcode
// _dio = Dio() => new hashcode
// _dio = Dio() => new hashcode
// _dio = Dio() => new hashcode
// _dio = Dio() => new hashcode
// _dio = Dio() => new hashcode
// _dio = Dio() => new hashcode
// _dio = Dio() => new hashcode
// _dio = Dio() => new hashcode
// _dio = Dio() => new hashcode


// Authentication => انت مين ؟
// Authorization  => صلاحياتك ايه ؟


// Login => 200 OK => ( AccessToken, RrefreshToken )
// AccessToken => 15min , 1h , 1d 
// RefreshToken => 30d ,  60d, 1y

// Web, Anroid Device, iOS Device ( 3 Access Tokens )
// ChangePassword => Logout from all devices
// Return new token => revoke previos tokens