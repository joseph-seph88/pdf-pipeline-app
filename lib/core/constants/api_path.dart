import 'package:pdf_pipeline_app/core/config/env.config.dart';

class ApiPath {
  ApiPath._();

  static String get baseUrl => '${EnvConfig.serverUrl}/api/v1';

  // Auth
  static final String login = '$baseUrl/auth/login';
  static final String signUp = '$baseUrl/auth/signup';
}
