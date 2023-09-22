import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';

class InfoWidget extends StatelessWidget {
  const InfoWidget({
    Key? key,
    required this.text,
    required this.icon,
  }) : super(key: key);

  final String text;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 1.0),
      decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: (CommonFunctions.isLightMode(context))
                ? AppColors.primaryColor
                : Colors.white,
          ),
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          (size.width > 330)
              ? Icon(
                  icon,
                  size: 20,
                  color: CommonFunctions.isLightMode(context)
                      ? AppColors.primaryColor
                      : Colors.white,
                )
              : const SizedBox(),
          SizedBox(width: (size.width > 330) ? 3 : 0),
          Text(
            text,
            style: TextStyle(
              fontFamily: AppFonts.mainArabicFontFamily,
              fontWeight: FontWeight.w700,
              fontSize: (size.width > 330) ? 12 : 8,
              color: (CommonFunctions.isLightMode(context))
                  ? AppColors.primaryColor
                  : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
