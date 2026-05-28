import 'dart:typed_data';
import 'package:fpdart/fpdart.dart';
import 'package:pdf_pipeline_app/core/errors/failure.dart';
import 'package:pdf_pipeline_app/core/network/api_response.dart';
import 'package:pdf_pipeline_app/core/entities/document.dart';

abstract interface class PdfConvertRepository {
  Future<Either<Failure, ApiResponse<Document>>> uploadDocument({
    required Uint8List bytes,
    required String fileName,
  });
}
