import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';

class DoctorDegreeWidget extends StatelessWidget {
  const DoctorDegreeWidget({
    Key? key,
    required this.degree,
  }) : super(key: key);

  final String degree;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.school_rounded,
          color: (CommonFunctions.isLightMode(context))
              ? AppColors.primaryColor
              : Colors.white,
          size: 35,
        ),
        const SizedBox(width: 8),
        Text(
          degree,
          style: TextStyle(
            fontFamily: AppFonts.mainArabicFontFamily,
            fontWeight: FontWeight.w600,
            fontSize: (size.width > 330) ? 22 : 18,
            color: (CommonFunctions.isLightMode(context))
                ? AppColors.primaryColor
                : Colors.white,
          ),
        ),
      ],
    );
  }
}
