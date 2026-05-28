import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:pdf_pipeline_app/core/entities/document.dart';
import 'package:pdf_pipeline_app/shared/theme/app_colors.dart';
import 'package:pdf_pipeline_app/core/utils/date_formatter.dart';
import 'package:pdf_pipeline_app/core/utils/size_formatter.dart';

class DocumentListItem extends StatelessWidget {
  const DocumentListItem({
    super.key,
    required this.document,
    required this.onTap,
    this.isSelectionMode = false,
    this.isSelected = false,
  });

  final Document document;
  final VoidCallback onTap;
  final bool isSelectionMode;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.06)
              : AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderDefault,
          ),
        ),
        child: Row(
          children: [
            if (isSelectionMode)
              Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  child: isSelected
                      ? Icon(Icons.check_circle,
                          color: AppColors.primary,
                          size: 22.sp,
                          key: const ValueKey(true))
                      : Icon(Icons.circle_outlined,
                          color: AppColors.borderDefault,
                          size: 22.sp,
                          key: const ValueKey(false)),
                ),
              )
            else
              Skeleton.replace(
                replacement: Container(
                  width: 42.w,
                  height: 42.w,
                  margin: EdgeInsets.only(right: 12.w),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8.r)),
                ),
                child: Container(
                  width: 42.w,
                  height: 42.w,
                  margin: EdgeInsets.only(right: 12.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(Icons.picture_as_pdf,
                      color: AppColors.primary, size: 22.sp),
                ),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    document.originalName,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textInverse,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${formatSize(document.fileSize)}  ·  ${formatDate(document.createdAt)}',
                    style: TextStyle(
                        fontSize: 12.sp, color: AppColors.textCaption),
                  ),
                ],
              ),
            ),
            if (!isSelectionMode)
              Icon(Icons.chevron_right,
                  color: AppColors.textCaption, size: 20.sp),
          ],
        ),
      ),
    );
  }
}
