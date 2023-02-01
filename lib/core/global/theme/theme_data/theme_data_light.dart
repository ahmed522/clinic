import 'package:flutter/material.dart';

import '../colors/light_theme_colors.dart';

ThemeData getThemeDataLight() {
  return ThemeData(
    primaryColor: LightThemeColors.primaryColor,
    primaryColorLight: LightThemeColors.primaryColorLight,
    primaryColorDark: LightThemeColors.primaryColorDark,
    appBarTheme: const AppBarTheme(
      color: LightThemeColors.primaryColor,
    ),
  );
}
