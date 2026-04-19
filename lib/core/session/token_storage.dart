import 'package:pdf_pipeline_app/core/constants/app_keys.dart';
import 'package:pdf_pipeline_app/core/storage/secure_storage.dart';

class TokenStorage {
  TokenStorage(this._storage);

  final SecureStorage _storage;

  Future<String?> getAccessToken() => _storage.read(AppKeys.tokenKey);

  Future<void> saveAccessToken(String token) =>
      _storage.write(AppKeys.tokenKey, token);

  Future<void> clearAccessToken() => _storage.delete(AppKeys.tokenKey);
}
