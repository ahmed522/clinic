import 'package:flutter/material.dart';

import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonst.dart';

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
        backgroundColor: AppColors.primaryColorDark,
      ),
    );
  }
}