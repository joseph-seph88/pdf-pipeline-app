import 'dart:typed_data';
import 'package:fpdart/fpdart.dart';
import 'package:pdf_pipeline_app/core/constants/api_path.dart';
import 'package:pdf_pipeline_app/core/errors/failure.dart';
import 'package:pdf_pipeline_app/core/network/api_client.dart';
import 'package:pdf_pipeline_app/core/network/api_response.dart';
import 'package:pdf_pipeline_app/core/models/document_model.dart';
import 'package:pdf_pipeline_app/core/entities/document.dart';
import 'package:pdf_pipeline_app/features/my_files/domain/repositories/my_files_repository.dart';

class MyFilesRepositoryImpl implements MyFilesRepository {
  const MyFilesRepositoryImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<Either<Failure, ApiResponse<List<Document>>>> getDocuments() {
    return _apiClient.get(
      ApiPath.documents,
      (data) => (data as List<dynamic>)
          .map((e) => DocumentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<Either<Failure, Uint8List>> downloadDocument(String url) {
    return _apiClient.downloadBytes(url);
  }
}
