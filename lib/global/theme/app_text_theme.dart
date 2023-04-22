import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonst.dart';
import 'package:flutter/material.dart';

class AppTextTheme {
  static TextStyle _getBodyText1Style(Brightness brightness) => TextStyle(
        color: brightness == Brightness.light
            ? AppColors.primaryColor
            : Colors.white,
        fontFamily: AppFonts.mainArabicFontFamily,
        fontWeight: FontWeight.w700,
        fontSize: 15,
      );
  static TextStyle _getBodyText2Style(Brightness brightness) => TextStyle(
        color: brightness == Brightness.light
            ? AppColors.primaryColor
            : Colors.white,
        fontFamily: AppFonts.mainArabicFontFamily,
        fontWeight: FontWeight.w700,
        fontSize: 25,
      );

  static TextTheme getAppTextTheme(Brightness brightness) => TextTheme(
        bodyText1: _getBodyText1Style(brightness),
        bodyText2: _getBodyText2Style(brightness),
      );
  static const TextStyle appBarTitleTextStyle = TextStyle(
    color: Colors.white,
    fontFamily: AppFonts.mainArabicFontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 17,
  );
}
