import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/theme/app_text_theme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData _getThemeData(Brightness brightness) => ThemeData(
        textTheme: AppTextTheme.getAppTextTheme(brightness),
        appBarTheme: AppBarTheme(
            backgroundColor: brightness == Brightness.light
                ? AppColors.primaryColor
                : AppColors.darkThemeBackgroundColor,
            titleTextStyle: AppTextTheme.appBarTitleTextStyle,
            iconTheme: const IconThemeData(color: Colors.white)),
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: AppColors.primaryColor,
              secondary: AppColors.primaryColor,
              brightness: brightness,
            ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: (brightness == Brightness.light)
                ? Colors.white
                : AppColors.darkThemeBackgroundColor,
            foregroundColor: (brightness == Brightness.light)
                ? AppColors.primaryColor
                : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: (brightness == Brightness.light)
                    ? AppColors.primaryColor
                    : Colors.white,
              ),
            ),
          ),
        ),
      );
  static ThemeData getLightTheme() => _getThemeData(Brightness.light);
  static ThemeData getDarkTheme() => _getThemeData(Brightness.dark);
}
