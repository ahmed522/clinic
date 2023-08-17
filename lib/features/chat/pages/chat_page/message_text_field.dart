import 'package:clinic/features/chat/controller/single_chat_page_controller.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageTextField extends StatelessWidget {
  const MessageTextField({
    Key? key,
    required this.chatterId,
  }) : super(key: key);

  final String chatterId;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GetX<SingleChatPageController>(
      tag: chatterId,
      builder: (controller) {
        return SizedBox(
          width: controller.currentUserType == UserType.user
              ? size.width - 140
              : size.width - 90,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 5,
            child: TextField(
              controller: controller.textController,
              decoration: InputDecoration(
                filled: true,
                fillColor: CommonFunctions.isLightMode(context)
                    ? Colors.white
                    : AppColors.darkThemeBottomNavBarColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                contentPadding: const EdgeInsets.all(10.0),
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              maxLines: null,
              cursorHeight: 20,
              onChanged: ((value) {
                if (controller.chatCreatedListener.isTrue) {
                  controller.updateIsTypingValue(true);
                  controller.debouncer.run(
                    () => controller.updateIsTypingValue(false),
                  );
                }
              }),
              enabled: !(controller.chat!.value.chatter1.blocks ||
                  controller.chat!.value.chatter1.isBlocked),
              keyboardType: TextInputType.multiline,
            ),
          ),
        );
      },
    );
  }
}
