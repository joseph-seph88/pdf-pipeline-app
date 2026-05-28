import 'package:flutter/material.dart';
import 'package:pdf_pipeline_app/shared/theme/app_colors.dart';
import 'package:pdf_pipeline_app/shared/widgets/app_primary_button.dart';
import '../widgets/auth_header.dart';

class SignUpTermsPage extends StatelessWidget {
  const SignUpTermsPage({
    super.key,
    required this.allAgreed,
    required this.termsAgreed,
    required this.privacyAgreed,
    required this.onAllChanged,
    required this.onTermsChanged,
    required this.onPrivacyChanged,
    required this.onNext,
    this.onTermsTap,
    this.onPrivacyTap,
  });

  final bool allAgreed;
  final bool termsAgreed;
  final bool privacyAgreed;
  final ValueChanged<bool?> onAllChanged;
  final ValueChanged<bool?> onTermsChanged;
  final ValueChanged<bool?> onPrivacyChanged;
  final VoidCallback? onNext;
  final VoidCallback? onTermsTap;
  final VoidCallback? onPrivacyTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 40),
          _buildAllAgreeRow(),
          const Divider(height: 32),
          _buildCheckRow(
            label: '[필수] 이용약관 동의',
            value: termsAgreed,
            onChanged: onTermsChanged,
            onTap: onTermsTap,
          ),
          const SizedBox(height: 12),
          _buildCheckRow(
            label: '[필수] 개인정보 처리방침 동의',
            value: privacyAgreed,
            onChanged: onPrivacyChanged,
            onTap: onPrivacyTap,
          ),
          const SizedBox(height: 32),
          AppPrimaryButton(label: '다음', onPressed: onNext),
        ],
      ),
    );
  }

  Widget _buildHeader() => const AuthHeader(
        title: '서비스 이용을 위해\n약관에 동의해주세요',
        subtitle: '필수 항목에 모두 동의해야 가입할 수 있어요',
      );

  Widget _buildAllAgreeRow() => Row(
        children: [
          Checkbox(
            value: allAgreed,
            onChanged: onAllChanged,
            activeColor: AppColors.primary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          const Text(
            '전체 동의',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      );

  Widget _buildCheckRow({
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged,
    VoidCallback? onTap,
  }) =>
      Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          Expanded(
            child: Text(label, style: const TextStyle(fontSize: 14)),
          ),
          if (onTap != null)
            IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: AppColors.textCaption,
              ),
              onPressed: onTap,
            ),
        ],
      );
}
