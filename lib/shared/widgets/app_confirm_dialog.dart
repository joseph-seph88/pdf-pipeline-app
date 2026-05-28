import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf_pipeline_app/shared/theme/app_colors.dart';

Future<void> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String content,
  required String confirmLabel,
  required VoidCallback onConfirm,
  String cancelLabel = '취소',
}) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: Text(cancelLabel, style: TextStyle(color: AppColors.textSub)),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
            onConfirm();
          },
          child: Text(confirmLabel, style: TextStyle(color: AppColors.error)),
        ),
      ],
    ),
  );
}
