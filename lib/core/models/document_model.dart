import 'package:pdf_pipeline_app/core/entities/document.dart';

class DocumentModel extends Document {
  const DocumentModel({
    required super.id,
    required super.originalName,
    required super.fileSize,
    required super.downloadUrl,
    required super.createdAt,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'] as String,
      originalName: json['originalName'] as String,
      fileSize: (json['fileSize'] as num).toInt(),
      downloadUrl: json['downloadUrl'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
