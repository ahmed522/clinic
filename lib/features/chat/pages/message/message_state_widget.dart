import 'package:clinic/features/chat/model/message_state.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';

class MessageStateWidget extends StatelessWidget {
  const MessageStateWidget({
    Key? key,
    required this.messageState,
  }) : super(key: key);
  final MessageState messageState;
  @override
  Widget build(BuildContext context) {
    return Icon(
      _stateIcon,
      size: 12,
      color: _stateIconColor(context),
    );
  }

  IconData get _stateIcon {
    switch (messageState) {
      case MessageState.sentOffline:
        return Icons.timelapse;
      case MessageState.sentOnline:
        return Icons.check_circle_outline_rounded;
      case MessageState.seen:
        return Icons.check_circle_rounded;
      case MessageState.error:
        return Icons.error_rounded;
      case MessageState.deleted:
        return Icons.delete_rounded;
    }
  }

  Color _stateIconColor(BuildContext context) {
    switch (messageState) {
      case MessageState.sentOffline:
        return CommonFunctions.isLightMode(context)
            ? Colors.black54
            : Colors.white54;
      case MessageState.sentOnline:
        return AppColors.primaryColor;
      case MessageState.seen:
        return Colors.green;
      case MessageState.error:
        return Colors.red;
      case MessageState.deleted:
        return Colors.amber;
    }
  }
}
