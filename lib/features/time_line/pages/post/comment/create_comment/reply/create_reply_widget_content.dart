import 'package:clinic/features/time_line/controller/create_reply_controller.dart';
import 'package:clinic/features/time_line/pages/post/comment/create_comment/reply/create_reply_text_field.dart';
import 'package:clinic/features/time_line/pages/post/comment/create_comment/reply/upload_reply_button.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateReplyWidgetContent extends StatelessWidget {
  const CreateReplyWidgetContent({
    Key? key,
    required this.postId,
    required this.commentId,
    required this.commentWriterId,
    required this.postWriterId,
    required this.postWriterType,
    required this.commentWriterType,
  }) : super(key: key);
  final String commentId;
  final String commentWriterId;
  final UserType commentWriterType;
  final String postId;
  final String postWriterId;
  final UserType postWriterType;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateReplyController());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        UploadReplyButton(
          commentId: commentId,
          commentWriterId: commentWriterId,
          commentWriterType: commentWriterType,
          postId: postId,
          postWriterId: postWriterId,
          postWriterType: postWriterType,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0, right: 5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CreateReplyTextField(),
              const SizedBox(width: 5),
              (controller.currentUserPersonalImage != null)
                  ? CircleAvatar(
                      backgroundImage:
                          NetworkImage(controller.currentUserPersonalImage!),
                      radius: 22,
                    )
                  : const CircleAvatar(
                      backgroundImage: AssetImage('assets/img/user.png'),
                      radius: 22,
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
