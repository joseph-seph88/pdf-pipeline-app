import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf_pipeline_app/features/my_files/presentation/notifiers/my_files_notifier.dart';
import 'package:pdf_pipeline_app/features/my_files/presentation/states/my_files_state.dart';
import 'package:pdf_pipeline_app/shared/theme/app_colors.dart';

AppBar buildMyFilesAppBar({
  required MyFilesState state,
  required MyFilesNotifier notifier,
}) {
  if (state.isSelectionMode) {
    return AppBar(
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.close, color: AppColors.textInverse, size: 22.sp),
        onPressed: notifier.exitSelectionMode,
      ),
      title: Text(
        state.hasSelection ? '${state.selectedIds.length}개 선택됨' : '항목 선택',
        style: TextStyle(
          fontSize: 17.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textInverse,
        ),
      ),
      actions: [
        TextButton(
          onPressed: state.hasSelection ? notifier.prepareShare : null,
          child: Text(
            '공유하기',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: state.hasSelection
                  ? AppColors.primary
                  : AppColors.textCaption,
            ),
          ),
        ),
      ],
    );
  }

  return AppBar(
    title: const Text('내 파일'),
    backgroundColor: AppColors.white,
    surfaceTintColor: AppColors.transparent,
    elevation: 0,
    titleTextStyle: TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w700,
      color: AppColors.textInverse,
    ),
    actions: [
      if (state.status == MyFilesStatus.success && !state.isEmpty)
        IconButton(
          icon: Icon(Icons.checklist_outlined,
              color: AppColors.textInverse, size: 22.sp),
          onPressed: notifier.enterSelectionMode,
        ),
    ],
  );
}
