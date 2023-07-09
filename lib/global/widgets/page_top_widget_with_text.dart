import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/page_top_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopPageWidgetWithText extends StatelessWidget {
  const TopPageWidgetWithText({
    Key? key,
    required this.text,
    required this.fontSize,
  }) : super(key: key);
  final String text;
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned(
          right: size.width / 2,
          top: size.height / 12,
          child: Text(
            text,
            style: TextStyle(
              color: (Theme.of(context).brightness == Brightness.dark)
                  ? Colors.white
                  : Colors.black,
              fontFamily: AppFonts.mainArabicFontFamily,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TopPageWidget(height: size.height / 5),
        Positioned(
            right: 20,
            top: size.height / 14,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_circle_right_outlined,
                color: (CommonFunctions.isLightMode(context))
                    ? Colors.white
                    : AppColors.darkThemeBackgroundColor,
                size: 40,
              ),
            )),
      ],
    );
  }
}
