import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf_pipeline_app/features/pdf_convert/presentation/states/pdf_convert_state.dart';
import 'package:pdf_pipeline_app/features/my_files/providers/my_files_providers.dart';
import 'package:pdf_pipeline_app/features/pdf_convert/providers/pdf_convert_providers.dart';
import 'package:pdf_pipeline_app/shared/theme/app_colors.dart';
import 'package:pdf_pipeline_app/shared/toast/app_toast.dart';
import '../widgets/pdf_convert_action_bar.dart';
import '../widgets/pdf_merge_list.dart';

class PdfConvertPage extends ConsumerStatefulWidget {
  const PdfConvertPage({super.key});

  @override
  ConsumerState<PdfConvertPage> createState() => _PdfConvertPageState();
}

class _PdfConvertPageState extends ConsumerState<PdfConvertPage> {
  @override
  Widget build(BuildContext context) {
    ref.listen(pdfConvertProvider, (previous, next) {
      if (previous?.status == next.status) return;
      if (next.status == PdfConvertStatus.success) {
        ref.invalidate(myFilesProvider);
        ref.read(pdfConvertProvider.notifier).reset();
      } else if (next.status == PdfConvertStatus.failure &&
          next.errorMessage != null) {
        AppToast.show(next.errorMessage!);
        ref.read(pdfConvertProvider.notifier).reset();
      }
    });

    final state = ref.watch(pdfConvertProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: PdfScanList(state: state)),
          PdfConvertActionBar(state: state),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('문서 스캔'),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textInverse,
      ),
    );
  }
}
