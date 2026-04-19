import 'package:fpdart/fpdart.dart';
import 'package:pdf_pipeline_app/core/errors/failure.dart';
import 'package:pdf_pipeline_app/core/network/api_response.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, ApiResponse<String>>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, ApiResponse<Unit>>> signUp({
    required String email,
    required String password,
    required String name,
    required bool termsAgreed,
    required bool privacyAgreed,
  });
}
