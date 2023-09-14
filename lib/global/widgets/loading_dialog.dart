import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      scrollable: true,
      title: Text(
        'بالرجاء الإنتظار',
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontFamily: AppFonts.mainArabicFontFamily,
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: (CommonFunctions.isLightMode(context))
              ? AppColors.darkThemeBackgroundColor
              : Colors.white,
        ),
      ),
      content: const Center(
        child: AppCircularProgressIndicator(
          height: 50,
          width: 50,
        ),
      ),
    );
  }
}
