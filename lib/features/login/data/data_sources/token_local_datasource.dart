// SharesPreferences => language, theme, 
// id, name, email, phone, username, type(admin,student,teacher)

// SecureStorage => accessToken, regreshToken
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenLocalDataSource {
  final FlutterSecureStorage _storage;

  const TokenLocalDataSource(this._storage);

  static const _accessToken = 'access_token';
  static const _refreshToken = 'refresh_token';

  Future<void> save({required String access, required String refresh}) async {
    await _storage.write(key: _accessToken, value: access);
    await _storage.write(key: _refreshToken, value: refresh);
  }

  Future<String?> get accessToken => _storage.read(key: _accessToken);
  Future<String?> get refreshToken => _storage.read(key: _refreshToken);

  Future<bool> get isLoggedIn async => (await accessToken) != null;

  Future<void> clear() async {
    await _storage.delete(key: _accessToken);
    await _storage.delete(key: _refreshToken);
  }
}