import 'package:clinic/features/time_line/model/comment_model.dart';
import 'package:clinic/features/time_line/model/reply_model.dart';
import 'package:clinic/features/time_line/pages/post/comment/comment_page.dart';
import 'package:clinic/features/time_line/pages/post/comment/react_comment_button.dart';
import 'package:clinic/features/time_line/pages/post/comment/react_reply_button.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentBottomWidget extends StatelessWidget {
  const CommentBottomWidget({
    Key? key,
    required this.comment,
    required this.isCommentPage,
    required this.isReply,
  }) : super(key: key);

  final CommentModel comment;
  final bool isCommentPage;
  final bool isReply;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        isCommentPage || isReply
            ? const SizedBox()
            : IconButton(
                iconSize: 20,
                padding: EdgeInsets.zero,
                onPressed: () => Get.to(CommentPage(comment: comment)),
                icon: Icon(
                  Icons.reply,
                  color: (CommonFunctions.isLightMode(context))
                      ? Colors.black87
                      : Colors.white70,
                ),
              ),
        const SizedBox(width: 2),
        isReply
            ? ReactReplyButton(reply: comment as ReplyModel)
            : ReactCommentButton(comment: comment),
      ],
    );
  }
}
