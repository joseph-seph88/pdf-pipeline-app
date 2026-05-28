import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf_pipeline_app/shared/theme/app_colors.dart';

class MyFilesEmptyView extends StatelessWidget {
  const MyFilesEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => ListView(
        children: [
          SizedBox(
            height: constraints.maxHeight,
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 96.w,
                          height: 96.w,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.cloud_upload_outlined,
                            size: 46.sp,
                            color: AppColors.primary.withValues(alpha: 0.5),
                          ),
                        ),
                        Container(
                          width: 36.w,
                          height: 36.w,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.backgroundGrey,
                              width: 2.5,
                            ),
                          ),
                          child: Icon(
                            Icons.picture_as_pdf,
                            size: 18.sp,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 28.h),
                    Text(
                      '업로드된 파일이 없어요',
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: AppColors.textInverse,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'PDF 변환 탭에서 이미지를 스캔하거나\nPDF를 병합해서 업로드해보세요',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.textCaption,
                        height: 1.65,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
