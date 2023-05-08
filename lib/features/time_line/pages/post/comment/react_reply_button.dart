import 'package:clinic/features/time_line/controller/comment_replies_controller.dart';
import 'package:clinic/features/time_line/model/reply_model.dart';
import 'package:clinic/features/time_line/pages/post/common/react_icon.dart';
import 'package:flutter/material.dart';

class ReactReplyButton extends StatelessWidget {
  const ReactReplyButton({
    Key? key,
    required this.reply,
  }) : super(key: key);
  final ReplyModel reply;
  @override
  Widget build(BuildContext context) {
    final controller = CommentRepliesController.find;
    return StatefulBuilder(builder: (context, setState) {
      return IconButton(
        iconSize: 20,
        padding: EdgeInsets.zero,
        onPressed: () {
          if (reply.reacted) {
            controller.unReactReply(reply.commentId, reply.replyId);
            setState(
              () => reply.reacted = false,
            );
          } else {
            controller.reactReply(reply.commentId, reply.replyId);
            setState(
              () => reply.reacted = true,
            );
          }
        },
        icon: ReactIcon(reacted: reply.reacted),
      );
    });
  }
}
