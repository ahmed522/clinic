import 'package:clinic/features/chat/model/message_state.dart';
import 'package:clinic/features/chat/pages/message/message_state_widget.dart';
import 'package:clinic/features/chat/pages/message/message_time_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageStateAndTimeWidget extends StatelessWidget {
  const MessageStateAndTimeWidget({
    Key? key,
    required this.messageTime,
    required this.messageState,
  }) : super(key: key);
  final Timestamp messageTime;
  final MessageState messageState;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MessageStateWidget(messageState: messageState),
        MessageTimeWidget(messageTime: messageTime),
      ],
    );
  }
}
