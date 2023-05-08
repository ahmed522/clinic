import 'package:clinic/features/time_line/controller/create_comment_controller.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:flutter/material.dart';

class CreateCommentTextField extends StatelessWidget {
  const CreateCommentTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = CreateCommentController.find;
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width / 2,
      child: TextField(
        controller: controller.textController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: (Theme.of(context).brightness == Brightness.light)
                  ? AppColors.primaryColor
                  : Colors.white,
            ),
          ),
          helperText: 'أضف تعليقك',
          helperStyle: TextStyle(
              color: (Theme.of(context).brightness == Brightness.light)
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
