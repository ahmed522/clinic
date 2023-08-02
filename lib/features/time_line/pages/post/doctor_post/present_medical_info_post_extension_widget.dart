import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:flutter/material.dart';

class PresentMedicalInfoPostExtensionWidget extends StatelessWidget {
  const PresentMedicalInfoPostExtensionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/img/medical-info.png',
              width: 80,
              height: 80,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'معلومة',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontFamily: AppFonts.mainArabicFontFamily,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'طبية',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontFamily: AppFonts.mainArabicFontFamily,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
