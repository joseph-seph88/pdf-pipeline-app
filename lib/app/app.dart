import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf_pipeline_app/app/router/app_router.dart';
import 'package:pdf_pipeline_app/core/theme/app_theme.dart';

class PdfPipelineApp extends ConsumerWidget {
  const PdfPipelineApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp.router(
        theme: AppTheme.light,
        themeMode: ThemeMode.light,
        routerConfig: ref.watch(appRouterProvider),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
