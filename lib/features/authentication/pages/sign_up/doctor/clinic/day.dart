import 'package:clinic/global/constants/app_constants.dart';
import 'package:flutter/material.dart';

import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonst.dart';

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
          color: (Theme.of(context).brightness == Brightness.light)
              ? AppColors.primaryColor
              : checked
                  ? AppColors.primaryColor
                  : Colors.white,
          width: 2,
        ),
        color: checked
            ? AppColors.primaryColor
            : (Theme.of(context).brightness == Brightness.light)
                ? Colors.white
                : AppColors.darkThemeBackgroundColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          day,
          style: TextStyle(
            fontFamily: AppFonts.mainArabicFontFamily,
            color: checked
                ? Colors.white
                : (Theme.of(context).brightness == Brightness.light)
                    ? AppColors.primaryColor
                    : Colors.white,
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
