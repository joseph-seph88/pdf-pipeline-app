import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pdf_pipeline_app/app/router/app_navigation.dart';
import 'package:pdf_pipeline_app/core/constants/image_path.dart';
import 'package:pdf_pipeline_app/core/di/core_provider.dart';
import 'package:pdf_pipeline_app/core/session/auth_state.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    WidgetsBinding.instance.addPostFrameCallback((_) => _onFirstFrame());
    _initAndNavigate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset(ImagePath.logo, width: 300, height: 300),
              const SizedBox(height: 24),
              SpinKitThreeBounce(color: Colors.black26, size: 38),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  void _setupAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  void _onFirstFrame() {
    FlutterNativeSplash.remove();
    _controller.forward();
  }

  Future<void> _initAndNavigate() async {
    await Future.wait([
      Future.delayed(const Duration(milliseconds: 2000)),
      ref.read(authStateProvider.notifier).initialize(
            ref.read(tokenStorageProvider),
          ),
    ]);

    if (!mounted) return;
    final status = ref.read(authStateProvider).status;

    if (status == AuthStatus.authenticated) {
      context.goToPdfConvert();
    } else {
      context.goToLogin();
    }
  }
}
