import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdfrx/pdfrx.dart' as pdfrx;
import 'package:pdf_pipeline_app/features/pdf_convert/presentation/states/pdf_convert_state.dart';
import 'package:pdf_pipeline_app/app/router/app_navigation.dart';
import 'package:pdf_pipeline_app/features/pdf_convert/providers/pdf_convert_providers.dart';
import 'package:pdf_pipeline_app/shared/theme/app_colors.dart';
import 'package:pdf_pipeline_app/shared/widgets/app_confirm_dialog.dart';
import 'package:pdf_pipeline_app/core/utils/size_formatter.dart';
import 'pdf_convert_empty_view.dart';

class PdfScanList extends ConsumerWidget {
  const PdfScanList({super.key, required this.state});

  final PdfConvertState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.scannedPdfs.isEmpty) {
      return const PdfConvertEmptyView(
        icon: Icons.document_scanner_outlined,
        title: '문서를 스캔하세요',
        subtitle: '카메라로 문서를 촬영하면\n엣지 감지 및 필터 적용 후 PDF로 저장됩니다',
      );
    }

    return ReorderableListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      buildDefaultDragHandles: false,
      itemCount: state.scannedPdfs.length,
      onReorder: (oldIndex, newIndex) => ref
          .read(pdfConvertProvider.notifier)
          .reorderScans(oldIndex, newIndex),
      itemBuilder: (context, index) {
        final file = state.scannedPdfs[index];
        return ReorderableDelayedDragStartListener(
          key: ValueKey(file.name + index.toString()),
          index: index,
          enabled: !state.isLoading,
          child: _PdfListItem(
            file: file,
            onTap: () => context.pushToPdfViewer(
              bytes: file.bytes,
              name: file.name,
            ),
            onRemoveTapped: state.isLoading
                ? null
                : () => _showDeleteDialog(context, ref, index),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, int index) {
    showConfirmDialog(
      context,
      title: '문서 삭제',
      content: '이 문서를 삭제하시겠습니까?',
      confirmLabel: '삭제',
      onConfirm: () => ref.read(pdfConvertProvider.notifier).removeScan(index),
    );
  }
}

class _PdfListItem extends StatelessWidget {
  const _PdfListItem({
    required this.file,
    required this.onTap,
    required this.onRemoveTapped,
  });

  final SelectedFile file;
  final VoidCallback onTap;
  final VoidCallback? onRemoveTapped;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.borderDefault),
        ),
        child: Row(
          children: [
            _PdfThumbnail(bytes: file.bytes),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    file.name,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textInverse,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    formatSize(file.bytes.length),
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textCaption,
                    ),
                  ),
                ],
              ),
            ),
            if (onRemoveTapped != null) ...[
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: onRemoveTapped,
                child: Icon(
                  Icons.close,
                  color: AppColors.textCaption,
                  size: 20.sp,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PdfThumbnail extends StatefulWidget {
  const _PdfThumbnail({required this.bytes});

  final Uint8List bytes;

  @override
  State<_PdfThumbnail> createState() => _PdfThumbnailState();
}

class _PdfThumbnailState extends State<_PdfThumbnail> {
  Uint8List? _thumbnail;

  @override
  void initState() {
    super.initState();
    _generateThumbnail();
  }

  Future<void> _generateThumbnail() async {
    try {
      final doc = await pdfrx.PdfDocument.openData(widget.bytes);
      if (doc.pages.isEmpty) {
        doc.dispose();
        return;
      }

      final page = doc.pages.first;
      final thumbWidth = 160;
      final thumbHeight = (thumbWidth * page.height / page.width).toInt();

      final render = await page.render(width: thumbWidth, height: thumbHeight);
      doc.dispose();
      if (render == null) return;

      final completer = Completer<Uint8List>();
      ui.decodeImageFromPixels(
        render.pixels,
        render.width,
        render.height,
        ui.PixelFormat.rgba8888,
        (image) async {
          final byteData =
              await image.toByteData(format: ui.ImageByteFormat.png);
          completer.complete(byteData!.buffer.asUint8List());
        },
      );
      final pngBytes = await completer.future;
      render.dispose();

      if (mounted) setState(() => _thumbnail = pngBytes);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final w = 56.w;
    final h = 76.h;

    return ClipRRect(
      borderRadius: BorderRadius.circular(6.r),
      child: _thumbnail != null
          ? Image.memory(
              _thumbnail!,
              width: w,
              height: h,
              fit: BoxFit.cover,
            )
          : Container(
              width: w,
              height: h,
              color: AppColors.backgroundGrey,
              child: Icon(
                Icons.picture_as_pdf,
                color: AppColors.pdfRed,
                size: 26.sp,
              ),
            ),
    );
  }
}
