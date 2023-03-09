import 'package:clinic/global/constants/app_constants.dart';
import 'package:flutter/material.dart';

import 'package:clinic/global/theme/colors/light_theme_colors.dart';
import 'package:clinic/global/theme/fonts/app_fonst.dart';

class Day extends StatelessWidget {
  final String day;
  final double size;
  final double fontSize;
  final bool checked;
  const Day(
      {super.key,
      this.day = 'سبت',
      this.size = AppConstants.dayBulletPhoneSize,
      this.fontSize = AppConstants.dayFontPhoneSize,
      this.checked = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(
          color: LightThemeColors.primaryColor,
          width: 2,
        ),
        color: checked ? LightThemeColors.primaryColor : Colors.white,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          day,
          style: TextStyle(
            fontFamily: AppFonts.mainArabicFontFamily,
            color: checked ? Colors.white : LightThemeColors.primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }

  static List<Widget> getClickableWeekDays(Map<String, bool> workDays,
      void Function(String day) onTap, BuildContext context) {
    List<Widget> weekDays = [];
    workDays.forEach((day, isChecked) {
      weekDays.add(
        GestureDetector(
          onTap: () => onTap(day),
          child: Day(
            day: day,
            checked: isChecked,
            size: (MediaQuery.of(context).size.width > AppConstants.phoneWidth)
                ? AppConstants.dayBulletTabletSize
                : AppConstants.dayBulletPhoneSize,
            fontSize:
                (MediaQuery.of(context).size.width > AppConstants.phoneWidth)
                    ? AppConstants.dayFontTabletSize
                    : AppConstants.dayFontPhoneSize,
          ),
        ),
      );
    });
    return weekDays;
  }
}
