import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';

class PresentNumberWidget extends StatelessWidget {
  const PresentNumberWidget({
    Key? key,
    required this.number,
    required this.fontSize,
  }) : super(key: key);

  final int number;
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        (number > 1000)
            ? Text(
                CommonFunctions.getMultiplierText(number),
                style: TextStyle(
                  fontFamily: AppFonts.mainArabicFontFamily,
                  color: (CommonFunctions.isLightMode(context))
                      ? Colors.black
                      : Colors.white,
                  fontSize: fontSize,
                ),
              )
            : const SizedBox(),
        Text(
          CommonFunctions.getNumberOfReactsText(number),
          style: TextStyle(
            fontFamily: AppFonts.mainArabicFontFamily,
            color: (CommonFunctions.isLightMode(context))
                ? Colors.black
                : Colors.white,
            fontSize: fontSize,
          ),
        ),
      ],
    );
  }
}
