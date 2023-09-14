import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/features/chat/model/chat_model.dart';
import 'package:clinic/features/chat/model/message_state.dart';
import 'package:clinic/features/chat/pages/chat_page/single_chat_page.dart';
import 'package:clinic/features/chat/pages/message/message_state_widget.dart';
import 'package:clinic/features/chat/pages/message/message_time_widget.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/notify_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SingleChatListTile extends StatefulWidget {
  const SingleChatListTile({
    Key? key,
    required this.chat,
  }) : super(key: key);
  final ChatModel chat;

  @override
  State<SingleChatListTile> createState() => _SingleChatListTileState();
}

class _SingleChatListTileState extends State<SingleChatListTile> {
  String? _chatterPic;
  @override
  void initState() {
    _getImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _getImage();
    String subTiltle =
        '${(widget.chat.lastMessage.sendedMessage) ? ' أنت : ' : ''}'
        '${widget.chat.lastMessage.content}';
    return ListTile(
      onTap: () => Get.to(
        () => SingleChatPage(
          chatterId: widget.chat.chatter2.id,
          chatterType: widget.chat.chatter2.userType,
          chatId: widget.chat.chatId,
        ),
        transition: Transition.rightToLeftWithFade,
      ),
      trailing: (_chatterPic == null)
          ? CircleAvatar(
              backgroundImage: const AssetImage('assets/img/user.png'),
              radius: 25,
              backgroundColor: (CommonFunctions.isLightMode(context))
                  ? Colors.grey.shade100
                  : AppColors.darkThemeBackgroundColor,
            )
          : CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                _chatterPic!,
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
          widget.chat.chatter2.name,
          style: const TextStyle(
            fontFamily: AppFonts.mainArabicFontFamily,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      subtitle: widget.chat.chatter2.isTyping
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
                fontSize: (!widget.chat.lastMessage.sendedMessage &&
                        widget.chat.lastMessage.messageState !=
                            MessageState.seen &&
                        widget.chat.lastMessage.messageState !=
                            MessageState.deleted)
                    ? 15
                    : 14,
                fontWeight: (!widget.chat.lastMessage.sendedMessage &&
                        widget.chat.lastMessage.messageState !=
                            MessageState.seen &&
                        widget.chat.lastMessage.messageState !=
                            MessageState.deleted)
                    ? FontWeight.w700
                    : FontWeight.w400,
              ),
            ),
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                CommonFunctions.getDate(widget.chat.lastMessage.messageTime),
                style: const TextStyle(
                  fontFamily: AppFonts.mainArabicFontFamily,
                  fontSize: 9,
                ),
              ),
              MessageTimeWidget(
                  messageTime: widget.chat.lastMessage.messageTime),
              (widget.chat.lastMessage.sendedMessage ||
                      widget.chat.lastMessage.messageState ==
                          MessageState.deleted)
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MessageStateWidget(
                            messageState: widget.chat.lastMessage.messageState),
                        widget.chat.lastMessage.isMedicalRecordMessage
                            ? const Icon(
                                Icons.medical_information,
                                color: AppColors.primaryColor,
                                size: 10,
                              )
                            : const SizedBox(),
                      ],
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        widget.chat.lastMessage.messageState !=
                                MessageState.seen
                            ? const NotifyWidget(
                                color: Colors.green,
                                shadowColor: Colors.lightGreen,
                                size: 10,
                              )
                            : const SizedBox(),
                        widget.chat.lastMessage.isMedicalRecordMessage
                            ? const Padding(
                                padding: EdgeInsets.only(left: 2.0),
                                child: Icon(
                                  Icons.medical_information,
                                  color: AppColors.primaryColor,
                                  size: 10,
                                ),
                              )
                            : const SizedBox(),
                      ],
                    )
            ],
          ),
          widget.chat.chatter1.muteNotifications
              ? const Icon(
                  Icons.volume_mute_rounded,
                  size: 25,
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  _getImage() {
    UserDataController.find
        .getUserPersonalImageURLById(
            widget.chat.chatter2.id, widget.chat.chatter2.userType)
        .then((value) {
      if (mounted) {
        setState(
          () {
            _chatterPic = value;
          },
        );
      }
    });
  }
}
