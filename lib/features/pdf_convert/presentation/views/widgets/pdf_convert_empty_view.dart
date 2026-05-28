import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf_pipeline_app/shared/theme/app_colors.dart';

class PdfConvertEmptyView extends StatelessWidget {
  const PdfConvertEmptyView({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 40.sp,
              color: AppColors.primaryLight,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textInverse,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textCaption,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
