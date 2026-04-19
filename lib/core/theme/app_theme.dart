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

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.white,
          brightness: Brightness.dark,
        ),
        fontFamily: 'Pretendard',
      );
}
