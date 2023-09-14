import 'package:flutter/material.dart';

import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:get/get.dart';

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

  static void showGetSnackbar(String message, Color color,
          {bool isTop = true,
          Duration duration = const Duration(milliseconds: 2000)}) =>
      Get.showSnackbar(
        GetSnackBar(
          messageText: Center(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: AppFonts.mainArabicFontFamily,
                fontSize: 20,
              ),
            ),
          ),
          backgroundColor: color,
          snackPosition: isTop ? SnackPosition.TOP : SnackPosition.BOTTOM,
          snackStyle: SnackStyle.GROUNDED,
          duration: duration,
          animationDuration: const Duration(milliseconds: 350),
        ),
      );
}
