import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_pipeline_app/core/constants/app_message.dart';
import 'package:pdf_pipeline_app/core/constants/server_status_type.dart';
import 'package:pdf_pipeline_app/core/entities/document.dart';
import 'package:pdf_pipeline_app/core/utils/pdf_merger.dart';
import 'package:pdf_pipeline_app/features/my_files/providers/my_files_providers.dart';
import '../states/my_files_state.dart';

class MyFilesNotifier extends Notifier<MyFilesState> {
  @override
  MyFilesState build() {
    Future.microtask(loadDocuments);
    return const MyFilesState(status: MyFilesStatus.loading);
  }

  Future<void> loadDocuments() async {
    state = state.copyWith(status: MyFilesStatus.loading);

    final result = await ref.read(myFilesRepositoryProvider).getDocuments();

    result.fold(
      (failure) => state = state.copyWith(
        status: MyFilesStatus.failure,
        errorMessage: failure.message,
      ),
      (response) {
        if (response.statusType != ServerStatusType.success.value ||
            response.data == null) {
          state = state.copyWith(
            status: MyFilesStatus.failure,
            errorMessage:
                ServerStatusType.fromValue(response.statusType)?.message ??
                    AppMessage.unknown,
          );
          return;
        }
        state = state.copyWith(
          status: MyFilesStatus.success,
          documents: response.data!,
        );
      },
    );
  }

  Future<void> openDocument(Document doc) async {
    state = state.copyWith(isDownloading: true);

    final result = await ref
        .read(myFilesRepositoryProvider)
        .downloadDocument(doc.downloadUrl);

    result.fold(
      (failure) => state = state.copyWith(
        isDownloading: false,
        downloadError: failure.message,
      ),
      (bytes) => state = state.copyWith(
        isDownloading: false,
        pendingBytes: bytes,
        pendingDocument: doc,
      ),
    );
  }

  void clearDownload() => state = state.withDownloadCleared();

  void enterSelectionMode() => state = state.copyWith(isSelectionMode: true);

  void exitSelectionMode() => state = state.withSelectionCleared();

  void toggleSelection(String id) {
    final updated = Set<String>.from(state.selectedIds);
    if (updated.contains(id)) {
      updated.remove(id);
    } else {
      updated.add(id);
    }
    state = state.copyWith(selectedIds: updated);
  }

  Future<void> prepareShare() async {
    if (!state.hasSelection || state.isProcessing) return;

    final docs =
        state.documents.where((d) => state.selectedIds.contains(d.id)).toList();

    state = state.copyWith(isMerging: true);

    final bytesList = <Uint8List>[];
    for (final doc in docs) {
      final result = await ref
          .read(myFilesRepositoryProvider)
          .downloadDocument(doc.downloadUrl);

      Uint8List? bytes;
      result.fold((_) {}, (b) => bytes = b);

      if (bytes == null) {
        state = state.copyWith(
            isMerging: false, mergeError: AppMessage.fileDownloadFailed);
        return;
      }
      bytesList.add(bytes!);
    }

    try {
      final merged = await PdfMerger.merge(bytesList);
      state = state.copyWith(isMerging: false, pendingShareBytes: merged);
    } catch (_) {
      state = state.copyWith(
          isMerging: false, mergeError: AppMessage.fileMergeFailed);
    }
  }

  void clearShareState() => state = state.withShareCleared();
}
