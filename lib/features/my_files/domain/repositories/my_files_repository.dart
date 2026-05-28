import 'dart:typed_data';
import 'package:fpdart/fpdart.dart';
import 'package:pdf_pipeline_app/core/entities/document.dart';
import 'package:pdf_pipeline_app/core/errors/failure.dart';
import 'package:pdf_pipeline_app/core/network/api_response.dart';

abstract interface class MyFilesRepository {
  Future<Either<Failure, ApiResponse<List<Document>>>> getDocuments();
  Future<Either<Failure, Uint8List>> downloadDocument(String url);
}
