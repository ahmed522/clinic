import 'package:clinic/features/chat/controller/single_chat_page_controller.dart';
import 'package:clinic/features/chat/model/message_model.dart';
import 'package:clinic/features/chat/pages/chat_page/block_widget.dart';
import 'package:clinic/features/chat/pages/chat_page/chat_bottom_widget.dart';
import 'package:clinic/features/chat/pages/chat_page/no_previous_messages_page.dart';
import 'package:clinic/features/chat/pages/message/message_widget.dart';
import 'package:clinic/features/chat/pages/chat_page/single_chat_page_appbar_widget.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:clinic/global/widgets/containered_text.dart';
import 'package:clinic/global/widgets/offline_page_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SingleChatPage extends StatelessWidget {
  const SingleChatPage({
    super.key,
    required this.chatterId,
    required this.chatterType,
    this.chatId,
  });
  final String chatterId;
  final UserType chatterType;
  final String? chatId;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Get.put(
        SingleChatPageController(
          chatterId: chatterId,
          chatterType: chatterType,
          screenHeight: size.height,
          chatId: chatId,
        ),
        tag: chatterId);

    return OfflinePageBuilder(
      child: GetX<SingleChatPageController>(
        tag: chatterId,
        builder: (controller) {
          if (controller.loading.isTrue) {
            return Container(
              color: CommonFunctions.isLightMode(context)
                  ? Colors.white
                  : AppColors.darkThemeBackgroundColor,
              child: const Center(
                child: AppCircularProgressIndicator(width: 100, height: 100),
              ),
            );
          }
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(70.0),
              child: SingleChatPageAppBarWidget(
                chatterId: chatterId,
                isCreated: controller.chatCreatedListener.value,
                blocks: controller.chat!.value.chatter1.blocks,
                deleteChat: controller.chat!.value.chatter1.deleteChat,
              ),
            ),
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  opacity: 0.18,
                  fit: BoxFit.cover,
                  image: AssetImage(
                    'assets/img/chat-background.jpg',
                  ),
                ),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  StreamBuilder(
                    stream: controller.chatCreatedListener.isFalse
                        ? controller.chatMessagesStream
                        : controller.chatMessagesStream,
                    builder: (context, snapshot) {
                      return GetX<SingleChatPageController>(
                        tag: chatterId,
                        builder: (controller) {
                          if (!snapshot.hasData ||
                              (snapshot.hasData &&
                                  snapshot.data!.docs.isEmpty)) {
                            if (controller.messageLoading.isTrue) {
                              return const Center(
                                child: AppCircularProgressIndicator(
                                  width: 100,
                                  height: 100,
                                ),
                              );
                            }
                            if ((snapshot.hasData &&
                                    snapshot.data!.docs.isEmpty) &&
                                ((controller.chat!.value.chatter1.blocks) ||
                                    (controller
                                        .chat!.value.chatter1.isBlocked))) {
                              return BlockWidget(
                                chatter1: controller.chat!.value.chatter1,
                                chatter2: controller.chat!.value.chatter2,
                              );
                            }
                            return const NoPreviousMessagesPage();
                          }

                          return ListView.builder(
                            controller: controller.scrollController,
                            reverse: true,
                            itemCount: snapshot.data!.docs.length,
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: (contex, index) {
                              MessageModel message = MessageModel.fromSnapshot(
                                snapshot.data!.docs[index],
                              );
                              message.sendedMessage = (message.senderId ==
                                  controller.currentUserId);
                              controller.updateSeenedMessage(message);
                              MessageModel? previousMessage;

                              if (index > 0) {
                                previousMessage = MessageModel.fromSnapshot(
                                    snapshot.data!.docs[index - 1]);
                              }

                              if (index == snapshot.data!.size - 1) {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: ContaineredText(
                                        text: _getMessagesDate(
                                            message.messageTime.toDate()),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        bottom: (index > 0) &&
                                                _setPaddingBeforeMessage(
                                                  currentMessage: message,
                                                  previousMessage:
                                                      previousMessage!,
                                                )
                                            ? 5
                                            : (index == 0)
                                                ? 80
                                                : 0,
                                      ),
                                      child: index == 0
                                          ? BlockWidget(
                                              message: message,
                                              chatter1: controller
                                                  .chat!.value.chatter1,
                                              chatter2: controller
                                                  .chat!.value.chatter2,
                                            )
                                          : Column(
                                              children: [
                                                MessageWidget(
                                                  message: message,
                                                ),
                                                _getMessagesDateDifference(
                                                  message.messageTime.toDate(),
                                                  previousMessage!.messageTime
                                                      .toDate(),
                                                )
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        child: ContaineredText(
                                                          text:
                                                              _getMessagesDate(
                                                            previousMessage
                                                                .messageTime
                                                                .toDate(),
                                                          ),
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                              ],
                                            ),
                                    ),
                                  ],
                                );
                              }

                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: (index == 0)
                                      ? 80
                                      : _setPaddingBeforeMessage(
                                              currentMessage: message,
                                              previousMessage: previousMessage!)
                                          ? 5
                                          : 0,
                                ),
                                child: index == 0
                                    ? BlockWidget(
                                        message: message,
                                        chatter1:
                                            controller.chat!.value.chatter1,
                                        chatter2:
                                            controller.chat!.value.chatter2,
                                      )
                                    : Column(
                                        children: [
                                          MessageWidget(
                                            message: message,
                                          ),
                                          _getMessagesDateDifference(
                                            message.messageTime.toDate(),
                                            previousMessage!.messageTime
                                                .toDate(),
                                          )
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: ContaineredText(
                                                    text: _getMessagesDate(
                                                      previousMessage
                                                          .messageTime
                                                          .toDate(),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                  ChatBottomWidget(chatterId: chatterId),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  bool _setPaddingBeforeMessage(
      {required MessageModel previousMessage,
      required MessageModel currentMessage}) {
    int messagesTimeDifference =
        CommonFunctions.calculateTimeDifferenceInMinutes(
            currentMessage.messageTime.toDate(),
            previousMessage.messageTime.toDate());
    bool longPeriodBetweenTowMessages = messagesTimeDifference > 10;
    if (currentMessage.senderId != previousMessage.senderId) {
      return true;
    } else if (longPeriodBetweenTowMessages) {
      return true;
    }
    return false;
  }

  String _getMessagesDate(DateTime messageDate) {
    if (CommonFunctions.isToday(messageDate)) {
      return 'اليوم';
    } else if (CommonFunctions.isYesterday(messageDate)) {
      return 'الأمس';
    } else {
      return messageDate.toString().substring(0, 10);
    }
  }

  bool _getMessagesDateDifference(
      DateTime messageDate1, DateTime messageDate2) {
    if (CommonFunctions.isSameDay(messageDate1, messageDate2)) {
      return false;
    } else {
      return true;
    }
  }
}
