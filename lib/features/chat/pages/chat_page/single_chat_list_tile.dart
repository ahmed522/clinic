import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinic/features/chat/model/chat_model.dart';
import 'package:clinic/features/chat/model/message_state.dart';
import 'package:clinic/features/chat/pages/chat_page/single_chat_page.dart';
import 'package:clinic/features/chat/pages/message/message_state_widget.dart';
import 'package:clinic/features/chat/pages/message/message_time_widget.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SingleChatListTile extends StatelessWidget {
  const SingleChatListTile({
    Key? key,
    required this.chat,
  }) : super(key: key);
  final ChatModel chat;
  @override
  Widget build(BuildContext context) {
    String subTiltle = '${(chat.lastMessage.sendedMessage) ? ' أنت : ' : ''}'
        '${chat.lastMessage.content}';
    return ListTile(
      onTap: () => Get.to(() => SingleChatPage(
            chatterId: chat.chatter2.id,
            chatterType: chat.chatter2.userType,
            chatId: chat.chatId,
          )),
      trailing: (chat.chatter2.picURL == null)
          ? CircleAvatar(
              backgroundImage: const AssetImage('assets/img/user.png'),
              radius: 25,
              backgroundColor: (CommonFunctions.isLightMode(context))
                  ? Colors.grey.shade100
                  : AppColors.darkThemeBackgroundColor,
            )
          : CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                chat.chatter2.picURL!,
              ),
              radius: 25,
              backgroundColor:
                  (Theme.of(context).brightness == Brightness.light)
                      ? Colors.grey.shade100
                      : AppColors.darkThemeBackgroundColor,
            ),
      title: Align(
        alignment: Alignment.centerRight,
        child: Text(
          chat.chatter2.name,
          style: const TextStyle(
            fontFamily: AppFonts.mainArabicFontFamily,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      subtitle: chat.chatter2.isTyping
          ? Text(
              'يكتب',
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            )
          : Text(
              subTiltle,
              maxLines: 1,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: AppFonts.mainArabicFontFamily,
                fontSize: (!chat.lastMessage.sendedMessage &&
                        chat.lastMessage.messageState != MessageState.seen &&
                        chat.lastMessage.messageState != MessageState.deleted)
                    ? 15
                    : 14,
                fontWeight: (!chat.lastMessage.sendedMessage &&
                        chat.lastMessage.messageState != MessageState.seen &&
                        chat.lastMessage.messageState != MessageState.deleted)
                    ? FontWeight.w700
                    : FontWeight.w400,
              ),
            ),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CommonFunctions.isToday(chat.lastMessage.messageTime.toDate())
              ? const Text(
                  'اليوم',
                  style: TextStyle(
                      fontFamily: AppFonts.mainArabicFontFamily, fontSize: 9),
                )
              : CommonFunctions.isYesterday(
                      chat.lastMessage.messageTime.toDate())
                  ? const Text(
                      'أمس',
                      style: TextStyle(
                          fontFamily: AppFonts.mainArabicFontFamily,
                          fontSize: 9),
                    )
                  : Text(
                      chat.lastMessage.messageTime
                          .toDate()
                          .toString()
                          .substring(0, 10),
                      style: const TextStyle(
                        fontFamily: AppFonts.mainArabicFontFamily,
                        fontSize: 9,
                      ),
                    ),
          MessageTimeWidget(messageTime: chat.lastMessage.messageTime),
          (chat.lastMessage.sendedMessage ||
                  chat.lastMessage.messageState == MessageState.deleted)
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MessageStateWidget(
                        messageState: chat.lastMessage.messageState),
                    chat.lastMessage.isMedicalRecordMessage
                        ? const Icon(
                            Icons.medical_information,
                            color: AppColors.primaryColor,
                            size: 12,
                          )
                        : const SizedBox(),
                  ],
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    chat.lastMessage.messageState != MessageState.seen
                        ? const Icon(
                            Icons.notifications_active_rounded,
                            color: Colors.green,
                            size: 15,
                          )
                        : const SizedBox(),
                    chat.lastMessage.isMedicalRecordMessage
                        ? const Icon(
                            Icons.medical_information,
                            color: AppColors.primaryColor,
                            size: 12,
                          )
                        : const SizedBox(),
                  ],
                )
        ],
      ),
    );
  }
}
