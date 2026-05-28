import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pdf_pipeline_app/core/network/api_client.dart';
import 'package:pdf_pipeline_app/core/network/dio_config.dart';
import 'package:pdf_pipeline_app/core/session/auth_notifier.dart';
import 'package:pdf_pipeline_app/core/session/auth_state.dart';
import 'package:pdf_pipeline_app/core/session/token_storage.dart';
import 'package:pdf_pipeline_app/core/storage/secure_storage.dart';

final secureStorageProvider = Provider<SecureStorage>(
  (ref) => SecureStorage(const FlutterSecureStorage()),
);

final tokenStorageProvider = Provider<TokenStorage>(
  (ref) => TokenStorage(ref.read(secureStorageProvider)),
);

final dioProvider = Provider<Dio>(
  (ref) => DioConfig.create(
    tokenStorage: ref.read(tokenStorageProvider),
    onUnauthorized: () =>
        ref.read(authStateProvider.notifier).setUnauthenticated(),
    onTokenExpired: () =>
        ref.read(authStateProvider.notifier).setTokenExpired(),
  ),
);

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(ref.read(dioProvider)),
);

final authStateProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
