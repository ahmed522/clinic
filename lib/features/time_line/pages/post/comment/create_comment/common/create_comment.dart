import 'package:clinic/features/time_line/pages/post/comment/comment_container.dart';
import 'package:clinic/features/time_line/pages/post/comment/create_comment/comment/create_comment_widget_content.dart';
import 'package:clinic/features/time_line/pages/post/comment/create_comment/reply/create_reply_widget_content.dart';
import 'package:flutter/material.dart';

class CreateCommentWidget extends StatelessWidget {
  const CreateCommentWidget({
    super.key,
    required this.postId,
    this.isReply = false,
    this.commentId = '',
    required this.postWriterId,
    this.commentWriterId,
  });
  final String postId;
  final String postWriterId;
  final String? commentWriterId;

  final bool isReply;
  final String commentId;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 10.0,
        right: isReply ? 15.0 : 10.0,
        left: isReply ? 15.0 : 10.0,
        bottom: 10.0,
      ),
      child: CommentContainer(
        borderWidth: 1,
        child: isReply
            ? CreateReplyWidgetContent(
                postId: postId,
                commentId: commentId,
                commentWriterId: commentWriterId!,
                postWriterId: postWriterId,
              )
            : CreateCommentWidgetContent(
                postId: postId,
                postWriterId: postWriterId,
              ),
      ),
    );
  }
}
