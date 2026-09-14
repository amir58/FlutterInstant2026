import 'package:navigations/features/login/data/data_sources/auth_datasource.dart';
import 'package:navigations/features/login/data/data_sources/token_local_datasource.dart';
import 'package:navigations/features/login/data/models/login_response.dart';

class AuthRepo {
  final AuthRemoteDataSource _remote;
  final TokenLocalDataSource _local;

  const AuthRepo(this._remote, this._local);

  // LoginScreen => Cubit => Repo => Remote => Local => Cubit =>
  //emit(LoginSuccessState) => LoginScreen => HomeScreen

  Future<LoginResponse> login({
    required String username,
    required String password,
  }) async {
    final loginResponse = await _remote.login(
      username: username,
      password: password,
    );

    // ⚠️ احفظ الأول، وبعدين رجّع النتيجة
    await _local.save(
      access: loginResponse.accessToken,
      refresh: loginResponse.refreshToken,
    );

    return loginResponse;
  }

  Future<void> logout() => _local.clear();

  Future<bool> get isLoggedIn => _local.isLoggedIn;

  // Future<UserModel> getCurrentUser() => _remote.getCurrentUser();
}
