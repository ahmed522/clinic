import 'package:clinic/features/time_line/controller/create_reply_controller.dart';
import 'package:clinic/features/time_line/model/reply_model.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/widgets/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UploadReplyButton extends StatelessWidget {
  const UploadReplyButton({
    Key? key,
    required this.commentId,
    required this.commentWriterId,
    required this.commentWriterType,
    required this.postId,
    required this.postWriterId,
    required this.postWriterType,
  }) : super(key: key);
  final String commentId;
  final String commentWriterId;
  final UserType commentWriterType;
  final String postId;
  final String postWriterId;
  final UserType postWriterType;

  @override
  Widget build(BuildContext context) {
    final controller = CreateReplyController.find;
    return TextButton(
      onPressed: () {
        if (controller.textController.text.trim() == '') {
          MySnackBar.showSnackBar(context, 'من فضلك أدخل ردك');
        } else {
          FocusScope.of(context).unfocus();
          ReplyModel reply = ReplyModel(
            postId: postId,
            writer: controller.currentUser,
            comment: controller.textController.text.trim(),
            commentTime: Timestamp.now(),
          );
          reply.commentId = commentId;

          controller.uploadReply(
            reply,
            commentWriterId,
            commentWriterType,
            postWriterId,
            postWriterType,
          );
        }
        controller.textController.clear();
      },
      child: Text(
        'نشر',
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}
