import 'package:dio/dio.dart';
import 'package:navigations/core/api/endpoints.dart';
import 'package:navigations/features/login/data/models/login_response.dart';

// SRP
class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._dio);

  final Dio _dio;

  Future<LoginResponse> login({
    required String username,
    required String password,
  }) async {
    // مفيش try/catch هنا — سيب الاستثناء يطلع للـ Repo
    final response = await _dio.post(
      EndPoints.login,
      data: {
        'username': username,
        'password': password,
        'expiresInMins': 30,
      },
    );

    return LoginResponse.fromJson(response.data);
  }

  // Future<UserModel> getCurrentUser() async {
  //   final response = await _dio.get(EndPoints.me);
  //   return UserModel.fromJson(response.data as Map<String, dynamic>);
  // }
}
