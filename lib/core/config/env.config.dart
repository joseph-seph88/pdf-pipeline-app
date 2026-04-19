import 'package:flutter_dotenv/flutter_dotenv.dart';

final class EnvConfig {
  EnvConfig._();

  static String _get(String key) =>
      dotenv.env[key] ?? (throw Exception('[$key] Not Found In .env'));

  static String get serverUrl => _get('SERVER_URL');
  static String get privacyPolicyUrl => _get('PRIVACY_POLICY_URL');
  static String get termsOfServiceUrl => _get('TERMS_URL');
}
