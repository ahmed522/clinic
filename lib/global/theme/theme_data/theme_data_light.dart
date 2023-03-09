import 'package:clinic/global/theme/colors/light_theme_colors.dart';
import 'package:flutter/material.dart';

ThemeData getThemeDataLight() {
  return ThemeData(
    colorScheme: ThemeData()
        .colorScheme
        .copyWith(primary: LightThemeColors.primaryColor),
    primaryColor: LightThemeColors.primaryColor,
    primaryColorLight: LightThemeColors.primaryColorLight,
    primaryColorDark: LightThemeColors.primaryColorDark,
    appBarTheme: const AppBarTheme(
      color: LightThemeColors.primaryColor,
    ),
  );
}
