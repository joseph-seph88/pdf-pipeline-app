import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppLoadingOverlay extends StatelessWidget {
  const AppLoadingOverlay({super.key, this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black26,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            if (label != null) ...[
              SizedBox(height: 16.h),
              Text(
                label!,
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
