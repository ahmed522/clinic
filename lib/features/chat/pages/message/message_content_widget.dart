import 'package:clinic/features/chat/controller/single_chat_page_controller.dart';
import 'package:clinic/features/chat/model/message_model.dart';
import 'package:clinic/features/chat/model/message_state.dart';
import 'package:clinic/features/chat/pages/message/medical_record_message_content.dart';
import 'package:clinic/features/chat/pages/message/message_info_widget.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:clinic/global/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:linkwell/linkwell.dart';

class MessageContentWidget extends StatelessWidget {
  const MessageContentWidget({
    Key? key,
    required this.message,
    this.isDialog = false,
  }) : super(key: key);

  final MessageModel message;
  final bool isDialog;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: isDialog ? null : () => _onMessagePressed(context),
      child: Padding(
        padding: EdgeInsets.only(
          right: message.sendedMessage ? 0.0 : 1.5,
          left: message.sendedMessage ? 1.5 : 0.0,
        ),
        child: Wrap(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              constraints: BoxConstraints(maxWidth: 3 * size.width / 4),
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    spreadRadius: 0.5,
                    blurRadius: 1,
                    offset: Offset(0, 0.5),
                  ),
                ],
                color: message.sendedMessage
                    ? AppColors.primaryColor
                    : CommonFunctions.isLightMode(context)
                        ? Colors.white
                        : AppColors.darkThemeBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: message.sendedMessage
                      ? const Radius.circular(10.0)
                      : const Radius.circular(2.0),
                  topRight: message.sendedMessage
                      ? const Radius.circular(2.0)
                      : const Radius.circular(10.0),
                  bottomLeft: message.sendedMessage
                      ? const Radius.circular(5.0)
                      : const Radius.circular(10.0),
                  bottomRight: message.sendedMessage
                      ? const Radius.circular(10.0)
                      : const Radius.circular(5.0),
                ),
              ),
              child: message.isMedicalRecordMessage
                  ? MedicalRecordMessageContent(
                      chatterId: message.sendedMessage
                          ? message.recieverId
                          : message.senderId,
                      messageId: message.messageId,
                      sendedMessage: message.sendedMessage,
                    )
                  : LinkWell(
                      message.content,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: AppFonts.mainArabicFontFamily,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: message.sendedMessage
                            ? Colors.white
                            : CommonFunctions.isLightMode(context)
                                ? Colors.black
                                : Colors.white,
                      ),
                      linkStyle: TextStyle(
                        fontFamily: AppFonts.mainArabicFontFamily,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: message.sendedMessage
                            ? Colors.blue.shade200
                            : Colors.blue,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  _onMessagePressed(BuildContext context) {
    final size = MediaQuery.of(context).size;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        scrollable: true,
        title: Text(
          'معلومات عن الرسالة',
          textAlign: TextAlign.end,
          style: TextStyle(
            fontFamily: AppFonts.mainArabicFontFamily,
            fontWeight: FontWeight.w700,
            fontSize: (size.width < 330) ? 17 : 20,
            color: (CommonFunctions.isLightMode(context))
                ? AppColors.darkThemeBackgroundColor
                : Colors.white,
          ),
        ),
        content: MessageInfoWidget(message: message),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actionsPadding: const EdgeInsets.only(bottom: 30),
        actions: (size.width < 330)
            ? _iconedActions(context)
            : MyAlertDialog.getAlertDialogActions(_actions(context)),
      ),
    );
  }

  Map<String, void Function()?> _actions(BuildContext context) {
    Map<String, void Function()?> actions = {
      'العودة': () => Get.back(),
    };
    actions.addIf(
      message.messageState != MessageState.deleted &&
          !message.isMedicalRecordMessage,
      'نسخ',
      () {
        Get.back();
        Clipboard.setData(ClipboardData(text: message.content));
        MySnackBar.showGetSnackbar('تم نسخ نص الرسالة', Colors.green);
      },
    );
    actions.addIf(
        (message.sendedMessage && message.messageState != MessageState.deleted),
        'حذف',
        () => _onDeleteMessageButtonPressed(context));
    return actions;
  }

  List<Widget> _iconedActions(BuildContext context) {
    List<Widget> actions = [
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
        ),
        onPressed: () => Get.back(),
        child: const Icon(
          Icons.close_rounded,
          color: Colors.white,
        ),
      ),
    ];
    actions.addIf(
      message.messageState != MessageState.deleted &&
          !message.isMedicalRecordMessage,
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          Get.back();
          Clipboard.setData(ClipboardData(text: message.content));
          MySnackBar.showGetSnackbar('تم نسخ نص الرسالة', Colors.green);
        },
        child: const Icon(
          Icons.copy_rounded,
          color: Colors.white,
        ),
      ),
    );
    actions.addIf(
      (message.sendedMessage && message.messageState != MessageState.deleted),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
        ),
        onPressed: () => _onDeleteMessageButtonPressed(context),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Colors.white,
        ),
      ),
    );
    return actions;
  }

  _onDeleteMessageButtonPressed(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return GetBuilder<SingleChatPageController>(
          tag: message.recieverId,
          builder: (controller) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              scrollable: true,
              title: Text(
                'حذف الرسالة',
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontFamily: AppFonts.mainArabicFontFamily,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: (CommonFunctions.isLightMode(context))
                      ? AppColors.darkThemeBackgroundColor
                      : Colors.white,
                ),
              ),
              content: controller.deleteMessageLoading
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'بالرجاء الإنتظار',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontFamily: AppFonts.mainArabicFontFamily,
                            fontSize: 15,
                            color: (CommonFunctions.isLightMode(context))
                                ? AppColors.darkThemeBackgroundColor
                                : Colors.white,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Center(
                            child: AppCircularProgressIndicator(
                              width: 50,
                              height: 50,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Text(
                        'هل أنت متأكد من حذف هذه الرسالة؟',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontFamily: AppFonts.mainArabicFontFamily,
                          fontSize: 15,
                          color: (CommonFunctions.isLightMode(context))
                              ? AppColors.darkThemeBackgroundColor
                              : Colors.white,
                        ),
                      ),
                    ),
              actionsAlignment: MainAxisAlignment.start,
              actionsPadding:
                  const EdgeInsets.only(left: 10, right: 10, bottom: 30),
              actions: MyAlertDialog.getAlertDialogActions(
                {
                  'إلغاء':
                      controller.deleteMessageLoading ? null : () => Get.back(),
                  'تأكيد': controller.deleteMessageLoading
                      ? null
                      : () {
                          controller.deleteMessage(message);
                          Get.back();
                          Get.back();
                        },
                },
              ),
            );
          },
        );
      },
    );
  }
}
