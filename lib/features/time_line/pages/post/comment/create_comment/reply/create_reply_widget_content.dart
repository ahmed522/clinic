import 'package:clinic/features/time_line/controller/create_reply_controller.dart';
import 'package:clinic/features/time_line/pages/post/comment/create_comment/reply/create_reply_text_field.dart';
import 'package:clinic/features/time_line/pages/post/comment/create_comment/reply/upload_reply_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateReplyWidgetContent extends StatelessWidget {
  const CreateReplyWidgetContent({
    Key? key,
    required this.postId,
    required this.commentId,
  }) : super(key: key);
  final String postId;
  final String commentId;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateReplyController());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        UploadReplyButton(postId: postId, commentId: commentId),
        Padding(
          padding: const EdgeInsets.only(top: 5.0, right: 5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CreateReplyTextField(),
              const SizedBox(width: 5),
              (controller.getCurrentUserPic() != null)
                  ? CircleAvatar(
                      backgroundImage:
                          NetworkImage(controller.getCurrentUserPic()),
                      radius: 25,
                    )
                  : const CircleAvatar(
                      backgroundImage: AssetImage('assets/img/user.png'),
                      radius: 25,
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
