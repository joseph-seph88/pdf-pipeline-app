import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_pipeline_app/app/router/app_navigation.dart';
import 'package:pdf_pipeline_app/core/theme/app_colors.dart';
import 'package:pdf_pipeline_app/shared/utils/app_toast.dart';
import '../../../providers/auth_providers.dart';
import '../../../presentation/states/login_state.dart';
import '../../../utils/auth_validator.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_text_field.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loginProvider).isLoading;
    _listenLoginState();

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 40),
                  _buildEmailField(),
                  const SizedBox(height: 16),
                  _buildPasswordField(),
                  const SizedBox(height: 28),
                  _buildLoginButton(isLoading),
                  const SizedBox(height: 12),
                  _buildSignUpRow(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _listenLoginState() {
    ref.listen(loginProvider, (_, next) {
      if (next.status == LoginStatus.failure) {
        AppToast.show(next.errorMessage ?? '');
        ref.read(loginProvider.notifier).reset();
      }
      if (next.status == LoginStatus.success) {
        context.goToPdfConvert();
      }
    });
  }

  Widget _buildHeader() => const AuthHeader(
        title: '로그인',
        subtitle: 'PDF Pipeline System에 오신 걸 환영해요',
      );

  Widget _buildEmailField() => AuthTextField(
        controller: _emailController,
        label: '이메일',
        keyboardType: TextInputType.emailAddress,
        validator: AuthValidator.email,
      );

  Widget _buildPasswordField() => AuthTextField(
        controller: _passwordController,
        label: '비밀번호',
        obscureText: _obscurePassword,
        validator: AuthValidator.password,
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: AppColors.textCaption,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
      );

  Widget _buildLoginButton(bool isLoading) =>
      AuthPrimaryButton(label: '로그인', onPressed: isLoading ? null : _onLogin);

  Widget _buildSignUpRow() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '계정이 없으신가요?',
            style: TextStyle(color: AppColors.textSub, fontSize: 14),
          ),
          TextButton(
            onPressed: () => context.pushToSignUp(),
            style:
                TextButton.styleFrom(foregroundColor: AppColors.primaryLight),
            child: const Text(
              '회원가입',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ],
      );

  void _onLogin() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    ref.read(loginProvider.notifier).login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }
}
