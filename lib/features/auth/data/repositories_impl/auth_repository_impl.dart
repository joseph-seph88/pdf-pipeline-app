import 'package:fpdart/fpdart.dart';
import 'package:pdf_pipeline_app/core/constants/api_path.dart';
import 'package:pdf_pipeline_app/core/errors/failure.dart';
import 'package:pdf_pipeline_app/core/network/api_client.dart';
import 'package:pdf_pipeline_app/core/network/api_response.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/sign_up_request.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<Either<Failure, ApiResponse<String>>> login({
    required String email,
    required String password,
  }) async {
    return _apiClient.post(
      ApiPath.login,
      (data) => (data as Map<String, dynamic>)['access_token'] as String,
      data: {'email': email, 'password': password},
    );
  }

  @override
  Future<Either<Failure, ApiResponse<Unit>>> signUp({
    required String email,
    required String password,
    required String name,
    required bool termsAgreed,
    required bool privacyAgreed,
  }) async {
    return _apiClient.post(
      ApiPath.signUp,
      (_) => unit,
      data: SignUpRequest(
        email: email,
        password: password,
        name: name,
        termsAgreed: termsAgreed,
        privacyAgreed: privacyAgreed,
      ).toJson(),
    );
  }
}
