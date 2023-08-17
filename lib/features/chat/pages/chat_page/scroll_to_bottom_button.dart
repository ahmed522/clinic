import 'package:clinic/features/chat/controller/single_chat_page_controller.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/circle_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScrollToBottomButton extends StatelessWidget {
  const ScrollToBottomButton({
    Key? key,
    required this.chatterId,
  }) : super(key: key);
  final String chatterId;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SingleChatPageController>(tag: chatterId);
    return CircleButton(
      onPressed: () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.scrollToBottom(2000);
        });
      },
      backgroundColor: CommonFunctions.isLightMode(context)
          ? Colors.white
          : AppColors.darkThemeBottomNavBarColor,
      foregroundColor: CommonFunctions.isLightMode(context)
          ? AppColors.primaryColor
          : Colors.white,
      child: Icon(
        Icons.arrow_drop_down_rounded,
        size: 30,
        color: CommonFunctions.isLightMode(context)
            ? AppColors.primaryColor
            : Colors.white,
      ),
    );
  }
}
