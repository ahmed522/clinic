import 'package:flutter/material.dart';

import '../../global/theme/colors/light_theme_colors.dart';
import '../../global/theme/fonts/app_fonst.dart';

class MySnackBar {
  static void showSnackBar(BuildContext context, String msg) {
    var scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.removeCurrentSnackBar();
    scaffoldMessenger.showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 1000),
        content: Text(
          msg,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: AppFonts.mainArabicFontFamily,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
          textAlign: TextAlign.end,
        ),
        backgroundColor: LightThemeColors.primaryColorDark,
      ),
    );
  }
}
