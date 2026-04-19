import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_pipeline_app/app/bootstrap.dart';
import 'package:pdf_pipeline_app/core/errors/error_handler.dart';
import 'package:pdf_pipeline_app/core/logger/app_logger.dart';
import 'app/app.dart';

void main() {
  runZonedGuarded(
    () async {
      final binding = WidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(widgetsBinding: binding);
      ErrorHandler.init();

      try {
        await Bootstrap.initCore().timeout(
          const Duration(seconds: 5),
          onTimeout: () => throw TimeoutException("[MAIN-부트스트랩] 5초 초과"),
        );
        await Bootstrap.initSystem();
      } catch (e, s) {
        logger.e("[MAIN-부트스트랩]초기화에러::", error: e, stackTrace: s);
      }

      runApp(const ProviderScope(child: PdfPipelineApp()));
    },
    (error, stack) {
      logger.e("[MAIN-ZONE에러]::", error: error, stackTrace: stack);
    },
  );
}
