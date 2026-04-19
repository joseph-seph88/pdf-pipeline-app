import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf_pipeline_app/core/logger/app_logger.dart';

class ErrorHandler {
  static void init() {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      logger.e(
        "[ErrorWidget]:: ${details.exception}",
        error: details.exception,
        stackTrace: details.stack,
      );
      return ErrorWidget(details.exception);
    };

    FlutterError.onError = (details) {
      logger.e(
        "[UI에러]:: ${details.exception}",
        error: details.exception,
        stackTrace: details.stack,
      );
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      logger.e("[비동기에러]::", error: error, stackTrace: stack);
      return true;
    };
  }
}
