import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pdf_pipeline_app/core/constants/api_path.dart';
import 'package:pdf_pipeline_app/core/errors/failure.dart';
import 'package:pdf_pipeline_app/core/network/api_client.dart';
import 'package:pdf_pipeline_app/core/network/api_response.dart';
import 'package:pdf_pipeline_app/core/models/document_model.dart';
import 'package:pdf_pipeline_app/core/entities/document.dart';
import '../../domain/repositories/pdf_convert_repository.dart';

class PdfConvertRepositoryImpl implements PdfConvertRepository {
  const PdfConvertRepositoryImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<Either<Failure, ApiResponse<Document>>> uploadDocument({
    required Uint8List bytes,
    required String fileName,
  }) {
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        bytes,
        filename: Uri.encodeComponent(fileName),
        contentType: DioMediaType('application', 'pdf'),
      ),
    });

    return _apiClient.post(
      ApiPath.documents,
      (data) => DocumentModel.fromJson(data as Map<String, dynamic>),
      data: formData,
    );
  }
}
