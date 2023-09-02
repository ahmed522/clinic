import 'package:clinic/features/chat/controller/single_chat_page_controller.dart';
import 'package:clinic/features/chat/pages/chat_page/message_text_field.dart';
import 'package:clinic/features/chat/pages/chat_page/new_message_in_chat_notification_widget.dart';
import 'package:clinic/features/chat/pages/chat_page/scroll_to_bottom_button.dart';
import 'package:clinic/features/chat/pages/chat_page/send_medical_record_button.dart';
import 'package:clinic/features/chat/pages/chat_page/send_message_button.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatBottomWidget extends StatelessWidget {
  const ChatBottomWidget({
    Key? key,
    required this.chatterId,
  }) : super(key: key);
  final String chatterId;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      right: 10,
      left: 10,
      child: GetX<SingleChatPageController>(
          tag: chatterId,
          builder: (controller) {
            return Column(
              children: [
                controller.showGoToBottomButton.isTrue ||
                        (controller.newMessages.isTrue &&
                            controller.scrolledup.isTrue)
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: Stack(
                          children: [
                            ScrollToBottomButton(chatterId: chatterId),
                            (controller.newMessages.isTrue &&
                                    controller.scrolledup.isTrue)
                                ? Positioned(
                                    left: 8,
                                    child: NewMessagesInChatNotificationWidget(
                                      newMessages:
                                          controller.numberOfNewMessages.value,
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    controller.currentUserType == UserType.user
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 3.0),
                            child: SendMedicalRecordButton(
                              chatterId: chatterId,
                              isBlocked: (controller
                                      .chat!.value.chatter1.blocks ||
                                  controller.chat!.value.chatter1.isBlocked),
                            ),
                          )
                        : const SizedBox(),
                    MessageTextField(chatterId: chatterId),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3.0),
                      child: SendMessageButton(chatterId: chatterId),
                    ),
                  ],
                ),
              ],
            );
          }),
    );
  }
}
