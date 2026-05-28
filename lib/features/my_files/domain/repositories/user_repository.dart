import 'dart:typed_data';
import 'package:fpdart/fpdart.dart';
import 'package:pdf_pipeline_app/core/entities/user.dart';
import 'package:pdf_pipeline_app/core/errors/failure.dart';
import 'package:pdf_pipeline_app/core/network/api_response.dart';

abstract interface class UserRepository {
  Future<Either<Failure, ApiResponse<User>>> getMe();
  Future<Either<Failure, ApiResponse<User>>> updateUser({
    String? nickname,
    Uint8List? imageBytes,
    String? imageFileName,
  });
  Future<Either<Failure, ApiResponse<User>>> deleteUser();
}
