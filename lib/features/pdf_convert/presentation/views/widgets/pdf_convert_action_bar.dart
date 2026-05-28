import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf_pipeline_app/features/pdf_convert/presentation/states/pdf_convert_state.dart';
import 'package:pdf_pipeline_app/features/pdf_convert/presentation/notifiers/pdf_convert_notifier.dart';
import 'package:pdf_pipeline_app/features/pdf_convert/providers/pdf_convert_providers.dart';
import 'package:pdf_pipeline_app/shared/theme/app_colors.dart';
import 'package:pdf_pipeline_app/shared/widgets/app_icon_action_button.dart';
import 'package:pdf_pipeline_app/shared/widgets/app_inline_loader.dart';
import 'package:pdf_pipeline_app/shared/widgets/app_primary_button.dart';
import 'package:pdf_pipeline_app/core/utils/date_formatter.dart';
import 'package:pdf_pipeline_app/shared/widgets/filename_input_sheet.dart';

class PdfConvertActionBar extends ConsumerWidget {
  const PdfConvertActionBar({super.key, required this.state});

  final PdfConvertState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(pdfConvertProvider.notifier);

    return Container(
      color: AppColors.white,
      padding: EdgeInsets.fromLTRB(
        20.w,
        12.h,
        20.w,
        12.h + MediaQuery.of(context).padding.bottom,
      ),
      child: state.isLoading
          ? AppInlineLoader(label: state.isProcessing ? '처리 중...' : '업로드 중...')
          : _ScanActionButtons(notifier: notifier, state: state),
    );
  }
}

class _ScanActionButtons extends StatelessWidget {
  const _ScanActionButtons({
    required this.notifier,
    required this.state,
  });

  final PdfConvertNotifier notifier;
  final PdfConvertState state;

  Future<void> _showFileNameSheet(BuildContext context) async {
    final defaultName = 'scan_${formatDateCompact(DateTime.now())}';

    final rawName =
        await showFilenameInputSheet(context, defaultName: defaultName);
    if (rawName == null) return;
    notifier.shareAndUpload(rawName);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppIconActionButton(
          icon: Icons.document_scanner_outlined,
          label: '스캔',
          onTap: notifier.scanDocument,
        ),
        SizedBox(width: 8.w),
        AppIconActionButton(
          icon: Icons.upload_file_outlined,
          label: 'PDF 추가',
          onTap: notifier.addPdfFromFile,
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: AppPrimaryButton(
            label: '공유하기',
            onPressed:
                state.hasItems ? () => _showFileNameSheet(context) : null,
          ),
        ),
      ],
    );
  }
}
