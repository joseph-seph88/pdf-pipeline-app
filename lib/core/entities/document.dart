import 'package:equatable/equatable.dart';

class Document extends Equatable {
  const Document({
    required this.id,
    required this.originalName,
    required this.fileSize,
    required this.downloadUrl,
    required this.createdAt,
  });

  final String id;
  final String originalName;
  final int fileSize;
  final String downloadUrl;
  final DateTime createdAt;

  @override
  List<Object?> get props =>
      [id, originalName, fileSize, downloadUrl, createdAt];
}
