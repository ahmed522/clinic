import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';

class ContaineredText extends StatelessWidget {
  final String text;
  final Color color;
  const ContaineredText({
    super.key,
    required this.text,
    this.color = AppColors.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: (CommonFunctions.isLightMode(context)) ? color : Colors.white,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontFamily: AppFonts.mainArabicFontFamily,
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: (CommonFunctions.isLightMode(context)) ? color : Colors.white,
        ),
      ),
    );
  }
}
