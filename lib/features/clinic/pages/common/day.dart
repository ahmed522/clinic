import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';

import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';

class Day extends StatelessWidget {
  const Day({
    super.key,
    this.day = 'سبت',
    this.size = AppConstants.dayBulletPhoneSize,
    this.fontSize = AppConstants.dayFontPhoneSize,
    this.checked = false,
  });

  final String day;
  final double size;
  final double fontSize;
  final bool checked;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(
          color: (CommonFunctions.isLightMode(context))
              ? AppColors.primaryColor
              : checked
                  ? AppColors.primaryColor
                  : Colors.white,
          width: 2,
        ),
        color: checked
            ? AppColors.primaryColor
            : (CommonFunctions.isLightMode(context))
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
                : (CommonFunctions.isLightMode(context))
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
      void Function(String day) onTap, BuildContext context,
      {int daysPerRow = 7, int firstIndex = 0}) {
    List<Widget> weekDays = [];
    int counter = daysPerRow;
    int index = firstIndex;
    workDays.forEach((day, isChecked) {
      if (counter != 0 && day == AppConstants.weekDays[index]) {
        weekDays.add(
          GestureDetector(
            onTap: () => onTap(day),
            child: Day(
              day: day,
              checked: isChecked,
              size:
                  (MediaQuery.of(context).size.width > AppConstants.phoneWidth)
                      ? AppConstants.dayBulletTabletSize
                      : AppConstants.dayBulletPhoneSize,
              fontSize:
                  (MediaQuery.of(context).size.width > AppConstants.phoneWidth)
                      ? AppConstants.dayFontTabletSize
                      : AppConstants.dayFontPhoneSize,
            ),
          ),
        );
        --counter;
        ++index;
      }
    });
    return weekDays;
  }
}
