import 'package:flutter/material.dart';
import 'package:pdf_pipeline_app/core/theme/app_colors.dart';
import '../../../utils/auth_validator.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_text_field.dart';

class SignUpInfoPage extends StatelessWidget {
  const SignUpInfoPage({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.obscureConfirm,
    required this.onTogglePassword,
    required this.onToggleConfirm,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool obscurePassword;
  final bool obscureConfirm;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirm;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 40),
                    _buildNameField(),
                    const SizedBox(height: 16),
                    _buildEmailField(),
                    const SizedBox(height: 16),
                    _buildPasswordField(),
                    const SizedBox(height: 16),
                    _buildConfirmPasswordField(),
                    const SizedBox(height: 32),
                    AuthPrimaryButton(label: '가입하기', onPressed: onSubmit),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() => const AuthHeader(
        title: '정보를 입력해주세요',
        subtitle: '가입에 필요한 정보를 입력해주세요',
      );

  Widget _buildNameField() => AuthTextField(
        controller: nameController,
        label: '이름',
        keyboardType: TextInputType.name,
        validator: AuthValidator.name,
      );

  Widget _buildEmailField() => AuthTextField(
        controller: emailController,
        label: '이메일',
        keyboardType: TextInputType.emailAddress,
        validator: AuthValidator.email,
      );

  Widget _buildPasswordField() => AuthTextField(
        controller: passwordController,
        label: '비밀번호',
        obscureText: obscurePassword,
        validator: AuthValidator.password,
        suffixIcon: IconButton(
          icon: Icon(
            obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: AppColors.textCaption,
          ),
          onPressed: onTogglePassword,
        ),
      );

  Widget _buildConfirmPasswordField() => AuthTextField(
        controller: confirmPasswordController,
        label: '비밀번호 확인',
        obscureText: obscureConfirm,
        validator: (v) =>
            AuthValidator.confirmPassword(v, passwordController.text),
        suffixIcon: IconButton(
          icon: Icon(
            obscureConfirm ? Icons.visibility_off : Icons.visibility,
            color: AppColors.textCaption,
          ),
          onPressed: onToggleConfirm,
        ),
      );
}
