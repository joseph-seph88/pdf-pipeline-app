import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:pdf_pipeline_app/core/entities/document.dart';

enum MyFilesStatus { idle, loading, success, failure }

class MyFilesState extends Equatable {
  const MyFilesState({
    this.status = MyFilesStatus.idle,
    this.documents = const [],
    this.errorMessage,
    this.isDownloading = false,
    this.pendingBytes,
    this.pendingDocument,
    this.downloadError,
    this.isSelectionMode = false,
    this.selectedIds = const {},
    this.isMerging = false,
    this.pendingShareBytes,
    this.mergeError,
  });

  final MyFilesStatus status;
  final List<Document> documents;
  final String? errorMessage;

  final bool isDownloading;
  final Uint8List? pendingBytes;
  final Document? pendingDocument;
  final String? downloadError;

  final bool isSelectionMode;
  final Set<String> selectedIds;
  final bool isMerging;
  final Uint8List? pendingShareBytes;
  final String? mergeError;

  bool get isLoading => status == MyFilesStatus.loading;
  bool get isEmpty => status == MyFilesStatus.success && documents.isEmpty;
  bool get hasSelection => selectedIds.isNotEmpty;
  bool get isProcessing => isDownloading || isMerging;

  MyFilesState copyWith({
    MyFilesStatus? status,
    List<Document>? documents,
    String? errorMessage,
    bool? isDownloading,
    Uint8List? pendingBytes,
    Document? pendingDocument,
    String? downloadError,
    bool? isSelectionMode,
    Set<String>? selectedIds,
    bool? isMerging,
    Uint8List? pendingShareBytes,
    String? mergeError,
  }) {
    return MyFilesState(
      status: status ?? this.status,
      documents: documents ?? this.documents,
      errorMessage: errorMessage ?? this.errorMessage,
      isDownloading: isDownloading ?? this.isDownloading,
      pendingBytes: pendingBytes ?? this.pendingBytes,
      pendingDocument: pendingDocument ?? this.pendingDocument,
      downloadError: downloadError ?? this.downloadError,
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
      selectedIds: selectedIds ?? this.selectedIds,
      isMerging: isMerging ?? this.isMerging,
      pendingShareBytes: pendingShareBytes ?? this.pendingShareBytes,
      mergeError: mergeError ?? this.mergeError,
    );
  }

  MyFilesState withDownloadCleared() => MyFilesState(
        status: status,
        documents: documents,
        errorMessage: errorMessage,
        isSelectionMode: isSelectionMode,
        selectedIds: selectedIds,
        isMerging: isMerging,
        pendingShareBytes: pendingShareBytes,
        mergeError: mergeError,
      );

  MyFilesState withShareCleared() => MyFilesState(
        status: status,
        documents: documents,
        errorMessage: errorMessage,
        isSelectionMode: isSelectionMode,
        selectedIds: selectedIds,
        isDownloading: isDownloading,
        pendingBytes: pendingBytes,
        pendingDocument: pendingDocument,
        downloadError: downloadError,
      );

  MyFilesState withSelectionCleared() => MyFilesState(
        status: status,
        documents: documents,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [
        status,
        documents,
        errorMessage,
        isDownloading,
        pendingBytes,
        pendingDocument,
        downloadError,
        isSelectionMode,
        selectedIds,
        isMerging,
        pendingShareBytes,
        mergeError,
      ];
}
