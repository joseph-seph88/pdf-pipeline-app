import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.white,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.white,
        // textTheme: AppTypography.textTheme,
        fontFamily: 'Pretendard',
      );
}
