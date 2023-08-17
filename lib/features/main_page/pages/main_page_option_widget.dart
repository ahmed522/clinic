import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';

import '../../../global/fonts/app_fonts.dart';

class MainPageOptionWidget extends StatelessWidget {
  const MainPageOptionWidget(
      {super.key,
      required this.onPressed,
      required this.selected,
      required this.optionName,
      required this.optionIcon});
  final void Function() onPressed;
  final bool selected;
  final String optionName;
  final IconData optionIcon;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(),
      child: Column(
        children: [
          Padding(
            padding: selected
                ? const EdgeInsets.only(top: 3.0)
                : const EdgeInsets.all(0.0),
            child: Icon(
              optionIcon,
              color: selected
                  ? AppColors.primaryColor
                  : (CommonFunctions.isLightMode(context))
                      ? Colors.black54
                      : Colors.white54,
              size: 30,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            optionName,
            style: TextStyle(
              color: selected
                  ? AppColors.primaryColor
                  : (CommonFunctions.isLightMode(context))
                      ? Colors.black54
                      : Colors.white54,
              fontFamily: AppFonts.mainArabicFontFamily,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
