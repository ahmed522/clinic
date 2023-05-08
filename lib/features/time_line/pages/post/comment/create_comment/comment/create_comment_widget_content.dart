import 'package:clinic/features/time_line/controller/create_comment_controller.dart';
import 'package:clinic/features/time_line/pages/post/comment/create_comment/comment/create_comment_text_field.dart';
import 'package:clinic/features/time_line/pages/post/comment/create_comment/comment/upload_comment_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateCommentWidgetContent extends StatelessWidget {
  const CreateCommentWidgetContent({
    Key? key,
    required this.postId,
  }) : super(key: key);

  final String postId;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateCommentController());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        UploadCommentButton(postId: postId),
        Padding(
          padding: const EdgeInsets.only(top: 5.0, right: 5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CreateCommentTextField(),
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
