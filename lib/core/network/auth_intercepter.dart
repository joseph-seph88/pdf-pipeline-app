import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf_pipeline_app/core/constants/api_path.dart';
import 'package:pdf_pipeline_app/core/constants/server_status_type.dart';
import 'package:pdf_pipeline_app/core/logger/app_logger.dart';
import 'package:pdf_pipeline_app/core/session/token_storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required TokenStorage tokenStorage,
    required VoidCallback onUnauthorized,
    required VoidCallback onTokenExpired,
  })  : _tokenStorage = tokenStorage,
        _onUnauthorized = onUnauthorized,
        _onTokenExpired = onTokenExpired;

  final TokenStorage _tokenStorage;
  final VoidCallback _onUnauthorized;
  final VoidCallback _onTokenExpired;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_shouldSkipAuth(options.path)) {
      return handler.next(options);
    }

    final token = await _tokenStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    final data = err.response?.data;
    final path = err.requestOptions.path;

    if (_shouldSkipAuth(path)) {
      return handler.next(err);
    }

    final raw = data is Map ? data['status_type'] : null;
    final statusType = raw is String ? raw : null;
    final isAuthError = statusCode == 401 || statusCode == 403;
    final isAuthStatusType =
        statusType == ServerStatusType.invalidToken.value ||
            statusType == ServerStatusType.authRequired.value ||
            statusType == ServerStatusType.unauthorized.value;

    if (isAuthError && isAuthStatusType) {
      logger.w('인증 에러 ($statusCode, $statusType)');
      // Refresh 토큰 로직은 프로덕션 레포에서...
      await _clearSession();

      if (statusType == ServerStatusType.invalidToken.value) {
        _onTokenExpired();
      } else {
        _onUnauthorized();
      }
      return handler.next(err);
    }

    handler.next(err);
  }

  bool _shouldSkipAuth(String path) {
    return path.startsWith(ApiPath.login) || path.startsWith(ApiPath.signUp);
  }

  Future<void> _clearSession() async {
    try {
      await _tokenStorage.clearAccessToken();
    } catch (e, s) {
      logger.e('세션 정리 실패', error: e, stackTrace: s);
    }
  }
}
