import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf_pipeline_app/core/entities/user.dart';
import 'package:pdf_pipeline_app/shared/theme/app_colors.dart';
import 'package:pdf_pipeline_app/shared/widgets/app_confirm_dialog.dart';

class MyFilesProfileCard extends StatelessWidget {
  const MyFilesProfileCard({
    super.key,
    required this.profile,
    required this.onLogout,
    required this.onEdit,
  });

  final User? profile;
  final VoidCallback onLogout;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onEdit,
      child: Container(
        margin: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.borderDefault),
        ),
        child: Row(
          children: [
            _Avatar(profile: profile),
            SizedBox(width: 14.w),
            Expanded(child: _ProfileInfo(profile: profile)),
            SizedBox(width: 8.w),
            Icon(Icons.edit_outlined,
                color: AppColors.textCaption, size: 18.sp),
            SizedBox(width: 12.w),
            _LogoutButton(onTap: () => _confirmLogout(context)),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showConfirmDialog(
      context,
      title: '로그아웃',
      content: '정말 로그아웃 하시겠어요?',
      confirmLabel: '로그아웃',
      onConfirm: onLogout,
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.profile});

  final User? profile;

  Widget _initialFallback(double size) => Container(
        width: size,
        height: size,
        color: AppColors.primary,
        child: Center(
          child: Text(
            profile?.initial ?? '?',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final size = 48.w;
    final imageUrl = profile?.profileImage;

    if (imageUrl == null) {
      return ClipOval(child: _initialFallback(size));
    }

    return ClipOval(
      child: Image.network(
        imageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _initialFallback(size),
      ),
    );
  }
}

class _ProfileInfo extends StatelessWidget {
  const _ProfileInfo({required this.profile});

  final User? profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          profile?.displayName ?? '불러오는 중...',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textInverse,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 3.h),
        Text(
          profile?.email ?? '',
          style: TextStyle(fontSize: 13.sp, color: AppColors.textCaption),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          '로그아웃',
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColors.error,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
