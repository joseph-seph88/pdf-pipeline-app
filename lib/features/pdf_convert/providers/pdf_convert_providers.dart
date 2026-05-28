import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_pipeline_app/core/di/core_provider.dart';
import '../data/repositories_impl/pdf_convert_repository_impl.dart';
import '../domain/repositories/pdf_convert_repository.dart';
import '../presentation/notifiers/pdf_convert_notifier.dart';
import '../presentation/states/pdf_convert_state.dart';

final pdfConvertRepositoryProvider = Provider<PdfConvertRepository>(
  (ref) => PdfConvertRepositoryImpl(ref.read(apiClientProvider)),
);

final pdfConvertProvider =
    NotifierProvider<PdfConvertNotifier, PdfConvertState>(
  PdfConvertNotifier.new,
);
