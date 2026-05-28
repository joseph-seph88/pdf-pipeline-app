import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf_pipeline_app/shared/theme/app_colors.dart';
import 'package:pdf_pipeline_app/shared/widgets/filename_input_sheet.dart';

class PdfViewerPage extends StatelessWidget {
  const PdfViewerPage({super.key, required this.bytes, required this.name});

  final Uint8List bytes;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: _buildAppBar(context),
      body: PdfViewer.data(bytes, sourceName: name),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textInverse,
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.share_outlined,
              color: AppColors.textInverse, size: 22.sp),
          onPressed: () => _share(context),
        ),
      ],
    );
  }

  Future<void> _share(BuildContext context) async {
    final baseName = name.toLowerCase().endsWith('.pdf')
        ? name.substring(0, name.length - 4)
        : name;

    final rawName =
        await showFilenameInputSheet(context, defaultName: baseName);
    if (rawName == null) return;

    final trimmed = rawName.trim();
    final fileName = trimmed.isEmpty
        ? name
        : trimmed.toLowerCase().endsWith('.pdf')
            ? trimmed
            : '$trimmed.pdf';

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes);
    await Share.shareXFiles([XFile(file.path)], subject: fileName);
  }
}
