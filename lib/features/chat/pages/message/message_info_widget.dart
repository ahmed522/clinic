import 'package:clinic/features/chat/model/message_model.dart';
import 'package:clinic/features/chat/model/message_state.dart';
import 'package:clinic/features/chat/pages/message/message_content_widget.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';

import 'message_state_widget.dart';

class MessageInfoWidget extends StatelessWidget {
  const MessageInfoWidget({
    Key? key,
    required this.message,
  }) : super(key: key);

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        MessageContentWidget(
          message: message,
          isDialog: true,
        ),
        const SizedBox(height: 20),
        (size.width < 330)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: _getTitleText('تاريخ الرسالة', context),
                  ),
                  Text(
                    _messageDate,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              )
            : ListTile(
                title: _getTitleText('تاريخ الرسالة', context),
                leading: Text(
                  _messageDate,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
        (size.width < 330)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: _getTitleText('وقت الرسالة', context),
                  ),
                  Text(
                    CommonFunctions.getTime(message.messageTime),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              )
            : ListTile(
                title: _getTitleText('وقت الرسالة', context),
                leading: Text(
                  CommonFunctions.getTime(message.messageTime),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
        message.sendedMessage || (message.messageState == MessageState.deleted)
            ? (size.width < 330)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: _getTitleText('حالة الرسالة', context),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MessageStateWidget(
                              messageState: message.messageState),
                          const SizedBox(width: 5),
                          Text(
                            _messageState,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                    ],
                  )
                : ListTile(
                    title: _getTitleText('حالة الرسالة', context),
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MessageStateWidget(messageState: message.messageState),
                        const SizedBox(width: 5),
                        Text(
                          _messageState,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                  )
            : const SizedBox(),
        (message.messageState == MessageState.deleted)
            ? (size.width < 330)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: _getTitleText('تاريخ حذف الرسالة', context),
                      ),
                      Text(
                        _messageDeletionDate,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  )
                : ListTile(
                    title: _getTitleText('تاريخ حذف الرسالة', context),
                    leading: Text(
                      _messageDeletionDate,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  )
            : const SizedBox(),
        (message.messageState == MessageState.deleted)
            ? (size.width < 330)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: _getTitleText('وقت حذف الرسالة', context),
                      ),
                      Text(
                        CommonFunctions.getTime(message.deletionTime!),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  )
                : ListTile(
                    title: _getTitleText('وقت حذف الرسالة', context),
                    leading: Text(
                      CommonFunctions.getTime(message.deletionTime!),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  )
            : const SizedBox(),
      ],
    );
  }

  Text _getTitleText(String text, BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Text(
      text,
      textAlign: TextAlign.end,
      style: TextStyle(
        fontFamily: AppFonts.mainArabicFontFamily,
        fontWeight: FontWeight.w500,
        fontSize: (size.width < 330) ? 13 : 15,
        color: (CommonFunctions.isLightMode(context))
            ? AppColors.darkThemeBackgroundColor
            : Colors.white,
      ),
    );
  }

  String get _messageDate =>
      message.messageTime.toDate().toString().substring(0, 10);
  String get _messageDeletionDate =>
      message.deletionTime!.toDate().toString().substring(0, 10);
  String get _messageState {
    switch (message.messageState) {
      case MessageState.sentOffline:
        return 'جار الإرسال';
      case MessageState.sentOnline:
        return 'تم الإرسال';
      case MessageState.seen:
        return 'تمت المشاهدة';
      case MessageState.error:
        return 'حدث خطأ';
      case MessageState.deleted:
        return 'محذوفة';
    }
  }
}
