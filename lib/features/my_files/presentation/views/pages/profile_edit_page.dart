import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf_pipeline_app/features/my_files/providers/my_files_providers.dart';
import 'package:pdf_pipeline_app/shared/theme/app_colors.dart';
import 'package:pdf_pipeline_app/shared/widgets/app_primary_button.dart';

class ProfileEditPage extends ConsumerStatefulWidget {
  const ProfileEditPage({super.key});

  @override
  ConsumerState<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends ConsumerState<ProfileEditPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final nickname = ref.read(userProvider).user?.nickname ?? '';
    _controller = TextEditingController(text: nickname);
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    final user = userState.user;
    final isUpdating = userState.isUpdating;
    final pendingImageBytes = userState.pendingImageBytes;
    final canSave =
        _controller.text.trim().isNotEmpty || pendingImageBytes != null;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 32.h),
              _ProfileImageSection(
                profileImageUrl: user?.profileImage,
                pendingImageBytes: pendingImageBytes,
                initial: user?.initial ?? '?',
                onTap: isUpdating ? null : _pickImage,
              ),
              SizedBox(height: 32.h),
              _buildNicknameLabel(),
              SizedBox(height: 8.h),
              _buildNicknameField(),
              SizedBox(height: 32.h),
              AppPrimaryButton(
                label: isUpdating ? '저장 중...' : '저장',
                onPressed: (isUpdating || !canSave) ? null : _save,
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.transparent,
      elevation: 0,
      title: Text(
        '프로필 수정',
        style: TextStyle(
          fontSize: 17.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textInverse,
        ),
      ),
    );
  }

  Widget _buildNicknameLabel() => Text(
        '닉네임',
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.textSub,
        ),
      );

  Widget _buildNicknameField() => TextField(
        controller: _controller,
        style: TextStyle(color: AppColors.textInverse, fontSize: 15.sp),
        decoration: InputDecoration(
          hintText: '닉네임을 입력하세요 (2자 이상)',
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: AppColors.borderDefault),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: AppColors.borderDefault),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: AppColors.primaryLight),
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        ),
      );

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 512,
      maxHeight: 512,
    );
    if (picked == null) return;

    final bytes = await picked.readAsBytes();
    ref.read(userProvider.notifier).setPendingImage(
          bytes: bytes,
          fileName: picked.name,
        );
  }

  Future<void> _save() async {
    await ref.read(userProvider.notifier).saveProfile(_controller.text);
    if (mounted) context.pop();
  }
}

class _ProfileImageSection extends StatelessWidget {
  const _ProfileImageSection({
    required this.initial,
    this.profileImageUrl,
    this.pendingImageBytes,
    this.onTap,
  });

  final String? profileImageUrl;
  final Uint8List? pendingImageBytes;
  final String initial;
  final VoidCallback? onTap;

  ImageProvider? get _imageProvider {
    if (pendingImageBytes != null) return MemoryImage(pendingImageBytes!);
    if (profileImageUrl != null) return NetworkImage(profileImageUrl!);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final image = _imageProvider;
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            _AvatarImage(image: image, initial: initial, size: 88.w),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.borderDefault),
                ),
                child: Icon(
                  Icons.camera_alt_outlined,
                  size: 16.sp,
                  color: AppColors.textSub,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarImage extends StatelessWidget {
  const _AvatarImage({
    required this.initial,
    required this.size,
    this.image,
  });

  final ImageProvider? image;
  final String initial;
  final double size;

  Widget _initialText() => Center(
        child: Text(
          initial,
          style: TextStyle(
            color: AppColors.white,
            fontSize: 36.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: _initialText(),
      );
    }

    return ClipOval(
      child: Image(
        image: image!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: size,
          height: size,
          color: AppColors.primary,
          child: _initialText(),
        ),
      ),
    );
  }
}
