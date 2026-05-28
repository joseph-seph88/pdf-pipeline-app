import 'package:pdf_pipeline_app/core/constants/app_keys.dart';
import 'package:pdf_pipeline_app/core/storage/secure_storage.dart';

class TokenStorage {
  TokenStorage(this._storage);

  final SecureStorage _storage;

  Future<String?> getAccessToken() => _storage.read(AppKeys.tokenKey);
  Future<void> saveAccessToken(String token) =>
      _storage.write(AppKeys.tokenKey, token);
  Future<void> clearAccessToken() => _storage.delete(AppKeys.tokenKey);

  Future<String?> getUserEmail() => _storage.read(AppKeys.userKey);
  Future<void> saveUserEmail(String email) =>
      _storage.write(AppKeys.userKey, email);
  Future<void> clearUserEmail() => _storage.delete(AppKeys.userKey);
}
