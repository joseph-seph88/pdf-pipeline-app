import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:pdf_pipeline_app/core/entities/document.dart';

enum PdfConvertStatus { idle, processing, uploading, success, failure }

class SelectedFile extends Equatable {
  const SelectedFile({required this.name, required this.bytes});

  final String name;
  final Uint8List bytes;

  @override
  List<Object?> get props => [name, bytes];
}

class PdfConvertState extends Equatable {
  const PdfConvertState({
    this.status = PdfConvertStatus.idle,
    this.scannedPdfs = const [],
    this.uploadedDocument,
    this.errorMessage,
  });

  final PdfConvertStatus status;
  final List<SelectedFile> scannedPdfs;
  final Document? uploadedDocument;
  final String? errorMessage;

  bool get isProcessing => status == PdfConvertStatus.processing;
  bool get isUploading => status == PdfConvertStatus.uploading;
  bool get isLoading => isProcessing || isUploading;
  bool get hasItems => scannedPdfs.isNotEmpty;

  PdfConvertState copyWith({
    PdfConvertStatus? status,
    List<SelectedFile>? scannedPdfs,
    Document? uploadedDocument,
    String? errorMessage,
  }) {
    return PdfConvertState(
      status: status ?? this.status,
      scannedPdfs: scannedPdfs ?? this.scannedPdfs,
      uploadedDocument: uploadedDocument ?? this.uploadedDocument,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, scannedPdfs, uploadedDocument, errorMessage];
}
