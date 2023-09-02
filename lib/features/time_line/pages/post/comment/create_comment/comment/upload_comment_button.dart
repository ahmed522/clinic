import 'package:clinic/features/time_line/controller/create_comment_controller.dart';
import 'package:clinic/features/time_line/model/comment_model.dart';
import 'package:clinic/global/widgets/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UploadCommentButton extends StatelessWidget {
  const UploadCommentButton({
    Key? key,
    required this.postId,
    required this.postWriterId,
  }) : super(key: key);
  final String postId;
  final String postWriterId;

  @override
  Widget build(BuildContext context) {
    final controller = CreateCommentController.find;
    return TextButton(
      onPressed: () {
        if (controller.textController.text.trim() == '') {
          MySnackBar.showSnackBar(context, 'من فضلك أدخل تعليقك');
        } else {
          FocusScope.of(context).unfocus();
          CommentModel comment = CommentModel(
            postId: postId,
            writer: controller.currentUser,
            comment: controller.textController.text.trim(),
            commentTime: Timestamp.now(),
          );
          controller.uploadComment(comment, postWriterId);
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
