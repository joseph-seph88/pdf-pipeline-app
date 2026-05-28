import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pdf_pipeline_app/shared/theme/app_colors.dart';

class AppInlineLoader extends StatelessWidget {
  const AppInlineLoader({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitThreeBounce(color: AppColors.primary, size: 18.sp),
          SizedBox(width: 12.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
