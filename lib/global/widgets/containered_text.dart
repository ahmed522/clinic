import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:flutter/material.dart';

class ContaineredText extends StatelessWidget {
  final String text;
  const ContaineredText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: (Theme.of(context).brightness == Brightness.light)
              ? AppColors.primaryColor
              : Colors.white,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: AppFonts.mainArabicFontFamily,
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: (Theme.of(context).brightness == Brightness.light)
              ? AppColors.primaryColor
              : Colors.white,
        ),
      ),
    );
  }
}
