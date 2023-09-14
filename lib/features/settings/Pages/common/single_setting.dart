import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';

class SingleSetting extends StatelessWidget {
  const SingleSetting({
    Key? key,
    required this.text,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);
  final String text;
  final IconData icon;
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Align(
        alignment: Alignment.centerRight,
        child: Text(
          text,
          style: TextStyle(
            color: CommonFunctions.isLightMode(context)
                ? AppColors.darkThemeBackgroundColor
                : Colors.white,
            fontFamily: AppFonts.mainArabicFontFamily,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ),
      trailing: Icon(
        icon,
        color: CommonFunctions.isLightMode(context)
            ? AppColors.darkThemeBackgroundColor
            : Colors.white,
      ),
      onTap: () => onPressed(),
    );
  }
}
