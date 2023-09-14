import 'package:clinic/features/chat/controller/single_chat_page_controller.dart';
import 'package:clinic/features/chat/pages/chat_page/medical_record_message_page.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/circle_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MedicalRecordMessageContent extends StatelessWidget {
  const MedicalRecordMessageContent({
    Key? key,
    required this.sendedMessage,
    required this.chatterId,
    required this.messageId,
  }) : super(key: key);

  final bool sendedMessage;
  final String messageId;
  final String chatterId;
  @override
  Widget build(BuildContext context) {
    final controller = SingleChatPageController.find(chatterId);
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleButton(
            onPressed: () {
              controller.onOpenMedicalRecordButtonPressed(
                  messageId, sendedMessage);
              Get.to(
                () => MedicalRecordMessagePage(
                  chatterId: chatterId,
                ),
                transition: Transition.rightToLeftWithFade,
              );
            },
            backgroundColor:
                sendedMessage ? Colors.white : AppColors.primaryColor,
            foregroundColor:
                sendedMessage ? AppColors.primaryColor : Colors.white,
            child: Text(
              'فتح',
              style: TextStyle(
                color: sendedMessage ? AppColors.primaryColor : Colors.white,
                fontFamily: AppFonts.mainArabicFontFamily,
                shadows: const [
                  BoxShadow(
                    color: Colors.black38,
                    spreadRadius: 0.3,
                    blurRadius: 0.5,
                    offset: Offset(0, 0.3),
                  ),
                ],
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            'سجل طبي',
            style: TextStyle(
              fontFamily: AppFonts.mainArabicFontFamily,
              fontSize: 18,
              color: sendedMessage
                  ? Colors.white
                  : CommonFunctions.isLightMode(context)
                      ? Colors.black
                      : Colors.white,
              fontWeight: sendedMessage ? FontWeight.w600 : FontWeight.w500,
              shadows: const [
                BoxShadow(
                  color: Colors.black38,
                  spreadRadius: 0.5,
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
