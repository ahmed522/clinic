import 'package:clinic/features/chat/pages/chat_page/single_chat_page.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:flutter/material.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:get/get.dart';

class ChatButton extends StatelessWidget {
  const ChatButton({
    Key? key,
    required this.userId,
    required this.userType,
  }) : super(key: key);
  final String userId;
  final UserType userType;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Get.to(
          () => SingleChatPage(
            chatterId: userId,
            chatterType: userType,
          ),
          transition: Transition.rightToLeftWithFade,
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: CommonFunctions.isLightMode(context)
            ? Colors.white
            : AppColors.darkThemeBackgroundColor,
        foregroundColor: CommonFunctions.isLightMode(context)
            ? AppColors.primaryColor
            : Colors.white,
        elevation: 5.0,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        side: BorderSide(
          width: .01,
          color: (CommonFunctions.isLightMode(context))
              ? AppColors.primaryColor
              : Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        'مراسلة',
        style: TextStyle(
          color: (CommonFunctions.isLightMode(context))
              ? AppColors.primaryColor
              : Colors.white,
          fontFamily: AppFonts.mainArabicFontFamily,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
