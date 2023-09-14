import 'package:clinic/features/time_line/pages/post/comment/comment_container.dart';
import 'package:clinic/features/time_line/pages/post/comment/create_comment/comment/create_comment_widget_content.dart';
import 'package:clinic/features/time_line/pages/post/comment/create_comment/reply/create_reply_widget_content.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:flutter/material.dart';

class CreateCommentWidget extends StatelessWidget {
  const CreateCommentWidget({
    super.key,
    this.isReply = false,
    this.commentId = '',
    this.commentWriterId,
    required this.postId,
    required this.postWriterId,
    required this.postWriterType,
    this.commentWriterType,
  });

  final String postId;
  final String postWriterId;
  final UserType postWriterType;
  final String commentId;
  final String? commentWriterId;
  final UserType? commentWriterType;
  final bool isReply;
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
                postWriterId: postWriterId,
                postWriterType: postWriterType,
                commentId: commentId,
                commentWriterId: commentWriterId!,
                commentWriterType: commentWriterType!,
              )
            : CreateCommentWidgetContent(
                postId: postId,
                postWriterId: postWriterId,
                postWriterType: postWriterType,
              ),
      ),
    );
  }
}
