import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pdf_pipeline_app/core/constants/api_path.dart';
import 'package:pdf_pipeline_app/core/entities/user.dart';
import 'package:pdf_pipeline_app/core/errors/failure.dart';
import 'package:pdf_pipeline_app/core/models/user_model.dart';
import 'package:pdf_pipeline_app/core/network/api_client.dart';
import 'package:pdf_pipeline_app/core/network/api_response.dart';
import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  const UserRepositoryImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<Either<Failure, ApiResponse<User>>> getMe() {
    return _apiClient.get(
      ApiPath.user,
      (data) => UserModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<Either<Failure, ApiResponse<User>>> updateUser({
    String? nickname,
    Uint8List? imageBytes,
    String? imageFileName,
  }) {
    if (imageBytes != null && imageFileName != null) {
      final formData = FormData.fromMap({
        'profileImage': MultipartFile.fromBytes(
          imageBytes,
          filename: imageFileName,
          contentType: DioMediaType('image', 'jpeg'),
        ),
        if (nickname != null) 'nickname': nickname,
      });
      return _apiClient.patch(
        ApiPath.user,
        (data) => UserModel.fromJson(data as Map<String, dynamic>),
        data: formData,
        options: Options(
          contentType: 'multipart/form-data; boundary=${formData.boundary}',
        ),
      );
    }

    return _apiClient.patch(
      ApiPath.user,
      (data) => UserModel.fromJson(data as Map<String, dynamic>),
      data: {
        if (nickname != null) 'nickname': nickname,
      },
    );
  }

  @override
  Future<Either<Failure, ApiResponse<User>>> deleteUser() {
    return _apiClient.delete(
      ApiPath.user,
      (data) => UserModel.fromJson(data as Map<String, dynamic>),
    );
  }
}
