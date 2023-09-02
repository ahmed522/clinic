import 'package:flutter/material.dart';

class NewMessagesInChatNotificationWidget extends StatelessWidget {
  const NewMessagesInChatNotificationWidget({
    Key? key,
    required this.newMessages,
  }) : super(key: key);
  final int newMessages;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: newMessages < 10 ? 6 : 4),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.green,
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            spreadRadius: 0.5,
            blurRadius: 1,
            offset: Offset(0, .5),
          ),
        ],
      ),
      child: Center(
        child: Text(
          newMessages.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 9,
            shadows: [
              BoxShadow(
                color: Colors.black38,
                spreadRadius: 0.5,
                blurRadius: 1,
                offset: Offset(0, .5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
