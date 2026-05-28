import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf_pipeline_app/app/router/app_navigation.dart';
import 'package:pdf_pipeline_app/shared/theme/app_colors.dart';
import 'package:pdf_pipeline_app/shared/toast/app_toast.dart';
import '../../../../../core/constants/terms.dart';
import '../../../providers/auth_providers.dart';
import '../../../presentation/states/sign_up_state.dart';
import 'sign_up_info_page.dart';
import 'sign_up_terms_page.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _allAgreed = false;
  bool _termsAgreed = false;
  bool _privacyAgreed = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(signUpProvider).isLoading;
    _listenSignUpState();

    return Scaffold(
      appBar: _buildAppBar(),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [_buildTermsPage(), _buildInfoPage(isLoading)],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        onPressed: () {
          if (_pageController.page == 1) {
            _pageController.previousPage(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
            );
          } else {
            context.pop();
          }
        },
      ),
    );
  }

  Widget _buildTermsPage() => SignUpTermsPage(
        allAgreed: _allAgreed,
        termsAgreed: _termsAgreed,
        privacyAgreed: _privacyAgreed,
        onAllChanged: _onAllAgreedChanged,
        onTermsChanged: (v) {
          setState(() => _termsAgreed = v ?? false);
          _updateAllAgreed();
        },
        onPrivacyChanged: (v) {
          setState(() => _privacyAgreed = v ?? false);
          _updateAllAgreed();
        },
        onNext: _termsAgreed && _privacyAgreed ? _nextPage : null,
        onTermsTap: () => _showTermsSheet('이용약관', Terms.terms),
        onPrivacyTap: () => _showTermsSheet('개인정보 처리방침', Terms.privacy),
      );

  void _showTermsSheet(String title, String content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, controller) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
              child: Text(
                title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
                child: Text(
                  content,
                  style: const TextStyle(fontSize: 14, height: 1.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoPage(bool isLoading) => SignUpInfoPage(
        formKey: _formKey,
        nameController: _nameController,
        emailController: _emailController,
        passwordController: _passwordController,
        confirmPasswordController: _confirmPasswordController,
        obscurePassword: _obscurePassword,
        obscureConfirm: _obscureConfirm,
        onTogglePassword: () =>
            setState(() => _obscurePassword = !_obscurePassword),
        onToggleConfirm: () =>
            setState(() => _obscureConfirm = !_obscureConfirm),
        onSubmit: isLoading ? null : _onSignUp,
      );

  void _listenSignUpState() {
    ref.listen(signUpProvider, (_, next) {
      if (next.status == SignUpStatus.failure) {
        AppToast.show(next.errorMessage ?? '');
        ref.read(signUpProvider.notifier).reset();
      }
      if (next.status == SignUpStatus.success) {
        ref.read(signUpProvider.notifier).reset();
        context.goToLogin();
      }
    });
  }

  void _onAllAgreedChanged(bool? value) {
    setState(() {
      _allAgreed = value ?? false;
      _termsAgreed = _allAgreed;
      _privacyAgreed = _allAgreed;
    });
  }

  void _updateAllAgreed() {
    setState(() => _allAgreed = _termsAgreed && _privacyAgreed);
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void _onSignUp() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    ref.read(signUpProvider.notifier).signUp(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          termsAgreed: _termsAgreed,
          privacyAgreed: _privacyAgreed,
        );
  }
}
