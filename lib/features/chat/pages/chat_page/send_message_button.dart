import 'package:clinic/global/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/single_chat_page_controller.dart';

class SendMessageButton extends StatelessWidget {
  const SendMessageButton({
    Key? key,
    required this.chatterId,
  }) : super(key: key);
  final String chatterId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: GetX<SingleChatPageController>(
        tag: chatterId,
        builder: (controller) {
          return ElevatedButton(
            onPressed: controller.chat!.value.chatter1.blocks ||
                    controller.chat!.value.chatter1.isBlocked
                ? null
                : () async => await controller.onSendButtonPressed(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.zero,
              shape: const CircleBorder(),
              elevation: 5,
            ),
            child: const Center(
              child: Icon(
                Icons.send_rounded,
                size: 25,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
