import 'package:clinic/features/chat/model/message_model.dart';
import 'package:clinic/features/chat/model/message_state.dart';
import 'package:clinic/features/chat/pages/message/message_content_widget.dart';
import 'package:clinic/features/chat/pages/message/message_state_and_time_widget.dart';
import 'package:clinic/features/chat/pages/message/message_state_widget.dart';
import 'package:clinic/features/chat/pages/message/message_time_widget.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    super.key,
    required this.message,
  });
  final MessageModel message;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          message.sendedMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(
          right: message.sendedMessage ? 4.0 : 0.0,
          left: message.sendedMessage ? 0.0 : 4.0,
          bottom: 3,
        ),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: message.sendedMessage
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: message.sendedMessage
                ? CrossAxisAlignment.stretch
                : CrossAxisAlignment.end,
            children: message.sendedMessage
                ? [
                    MessageStateAndTimeWidget(
                      messageState: message.messageState,
                      messageTime: message.messageTime,
                    ),
                    MessageContentWidget(
                      message: message,
                    ),
                  ]
                : [
                    MessageContentWidget(
                      message: message,
                    ),
                    (message.messageState == MessageState.deleted)
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MessageStateWidget(
                                messageState: message.messageState,
                              ),
                              MessageTimeWidget(
                                messageTime: message.messageTime,
                              ),
                            ],
                          )
                        : MessageTimeWidget(
                            messageTime: message.messageTime,
                          ),
                  ],
          ),
        ),
      ),
    );
  }
}
