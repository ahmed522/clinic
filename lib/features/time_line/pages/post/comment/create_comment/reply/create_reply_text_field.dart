import 'package:clinic/features/time_line/controller/create_reply_controller.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';

class CreateReplyTextField extends StatelessWidget {
  const CreateReplyTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = CreateReplyController.find;
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: (size.width > 320) ? size.width / 2 : size.width / 3,
      child: TextField(
        controller: controller.textController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: (CommonFunctions.isLightMode(context))
                  ? AppColors.primaryColor
                  : Colors.white,
            ),
          ),
          helperText: 'أضف ردك',
          helperStyle: TextStyle(
              color: (CommonFunctions.isLightMode(context))
                  ? AppColors.darkThemeBackgroundColor
                  : Colors.white,
              fontFamily: AppFonts.mainArabicFontFamily,
              fontWeight: FontWeight.w500,
              fontSize: 10),
        ),
        maxLength: 400,
        maxLines: 2,
        textAlign: TextAlign.end,
      ),
    );
  }
}
