import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf_pipeline_app/core/constants/api_path.dart';
import 'package:pdf_pipeline_app/core/network/auth_intercepter.dart';
import 'package:pdf_pipeline_app/core/session/token_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioConfig {
  static Dio create({
    required TokenStorage tokenStorage,
    required VoidCallback onUnauthorized,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiPath.baseUrl,
        headers: {'Content-Type': 'application/json'},
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    )..interceptors.add(
        AuthInterceptor(tokenStorage: tokenStorage, onUnauthorized: onUnauthorized),
      );

    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: true,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }

    return dio;
  }
}
