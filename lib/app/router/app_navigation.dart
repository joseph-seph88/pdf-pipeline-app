import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf_pipeline_app/app/router/router_path.dart';

extension RouterNavigation on BuildContext {
  // GO
  void goToSplash() => go(RouterPath.splash);
  void goToLogin() => go(RouterPath.login);
  void goToPdfConvert() => go(RouterPath.pdfConvert);
  void goToMyFiles() => go(RouterPath.myFiles);

  // PUSH
  void pushToSignUp() => push(RouterPath.signUp);
}
