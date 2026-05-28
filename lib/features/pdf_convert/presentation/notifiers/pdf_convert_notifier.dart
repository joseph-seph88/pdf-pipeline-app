import 'dart:io';
import 'package:doc_scan_flutter/doc_scan.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf_pipeline_app/core/constants/app_message.dart';
import 'package:pdf_pipeline_app/core/constants/server_status_type.dart';
import 'package:pdf_pipeline_app/core/entities/document.dart';
import 'package:pdf_pipeline_app/core/utils/date_formatter.dart';
import 'package:pdf_pipeline_app/core/utils/pdf_merger.dart';
import '../../providers/pdf_convert_providers.dart';
import '../states/pdf_convert_state.dart';

class PdfConvertNotifier extends Notifier<PdfConvertState> {
  @override
  PdfConvertState build() {
    ref.keepAlive();
    return const PdfConvertState();
  }

  Future<void> scanDocument() async {
    if (state.isLoading) return;
    try {
      final paths = await DocumentScanner.scan(format: DocScanFormat.pdf);
      if (paths == null || paths.isEmpty) return;

      final bytes = await File(paths.first).readAsBytes();
      final name = 'scan_${DateTime.now().millisecondsSinceEpoch}.pdf';
      state = state.copyWith(
        scannedPdfs: [
          ...state.scannedPdfs,
          SelectedFile(name: name, bytes: bytes)
        ],
      );
    } on DocumentScannerException catch (e) {
      state = state.copyWith(
        status: PdfConvertStatus.failure,
        errorMessage: e.message,
      );
    } catch (_) {
      state = state.copyWith(
        status: PdfConvertStatus.failure,
        errorMessage: AppMessage.scanFailed,
      );
    }
  }

  Future<void> addPdfFromFile() async {
    if (state.isLoading) return;
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: true,
      );
      if (result == null || result.files.isEmpty) return;
      final added = <SelectedFile>[];
      for (final f in result.files) {
        final bytes = f.bytes ??
            (f.path != null ? await File(f.path!).readAsBytes() : null);
        if (bytes == null) continue;
        added.add(SelectedFile(name: f.name, bytes: bytes));
      }
      if (added.isEmpty) return;
      state = state.copyWith(scannedPdfs: [...state.scannedPdfs, ...added]);
    } catch (_) {
      state = state.copyWith(
        status: PdfConvertStatus.failure,
        errorMessage: AppMessage.pdfPickFailed,
      );
    }
  }

  void removeScan(int index) {
    if (state.isLoading) return;
    final list = List<SelectedFile>.from(state.scannedPdfs)..removeAt(index);
    state = state.copyWith(scannedPdfs: list);
  }

  void reorderScans(int oldIndex, int newIndex) {
    if (state.isLoading) return;
    final list = List<SelectedFile>.from(state.scannedPdfs);
    if (newIndex > oldIndex) newIndex--;
    list.insert(newIndex, list.removeAt(oldIndex));
    state = state.copyWith(scannedPdfs: list);
  }

  Future<void> shareAndUpload(String rawName) async {
    if (!state.hasItems || state.isLoading) return;

    final trimmed = rawName.trim();
    final fileName = trimmed.isEmpty
        ? 'scan_${formatTimestamp(DateTime.now())}.pdf'
        : trimmed.toLowerCase().endsWith('.pdf')
            ? trimmed
            : '$trimmed.pdf';

    state = state.copyWith(status: PdfConvertStatus.processing);

    try {
      final pdfBytes =
          await PdfMerger.merge(state.scannedPdfs.map((f) => f.bytes).toList());

      const maxBytes = 50 * 1024 * 1024;
      if (pdfBytes.length > maxBytes) {
        final sizeMb = (pdfBytes.length / 1024 / 1024).toStringAsFixed(1);
        state = state.copyWith(
          status: PdfConvertStatus.failure,
          errorMessage: AppMessage.fileSizeExceeded(sizeMb),
        );
        return;
      }

      state = state.copyWith(status: PdfConvertStatus.uploading);

      final result = await ref
          .read(pdfConvertRepositoryProvider)
          .uploadDocument(bytes: pdfBytes, fileName: fileName);

      final uploadFailed = result.fold(
        (failure) {
          state = state.copyWith(
            status: PdfConvertStatus.failure,
            errorMessage: failure.message,
          );
          return true;
        },
        (response) {
          if (response.statusType != ServerStatusType.success.value ||
              response.data == null) {
            state = state.copyWith(
              status: PdfConvertStatus.failure,
              errorMessage:
                  ServerStatusType.fromValue(response.statusType)?.message ??
                      AppMessage.unknown,
            );
            return true;
          }
          return false;
        },
      );

      if (uploadFailed) return;

      Document? uploadedDocument;
      result.fold((_) {}, (response) => uploadedDocument = response.data);

      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/$fileName';
      await File(filePath).writeAsBytes(pdfBytes);

      state = state.copyWith(
        status: PdfConvertStatus.success,
        uploadedDocument: uploadedDocument,
        scannedPdfs: [],
      );

      await Share.shareXFiles(
        [XFile(filePath)],
        subject: fileName,
      );
    } catch (_) {
      state = state.copyWith(
        status: PdfConvertStatus.failure,
        errorMessage: AppMessage.processFailed,
      );
    }
  }

  void reset() => state = const PdfConvertState();
}
