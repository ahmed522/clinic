import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinic/features/time_line/controller/create_comment_controller.dart';
import 'package:clinic/features/time_line/pages/post/comment/create_comment/comment/create_comment_text_field.dart';
import 'package:clinic/features/time_line/pages/post/comment/create_comment/comment/upload_comment_button.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateCommentWidgetContent extends StatelessWidget {
  const CreateCommentWidgetContent({
    Key? key,
    required this.postId,
    required this.postWriterId,
    required this.postWriterType,
  }) : super(key: key);

  final String postId;
  final String postWriterId;
  final UserType postWriterType;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateCommentController());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        UploadCommentButton(
          postId: postId,
          postWriterId: postWriterId,
          postWriterType: postWriterType,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0, right: 5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CreateCommentTextField(),
              const SizedBox(width: 5),
              (controller.currentUserPersonalImage != null)
                  ? CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                          controller.currentUserPersonalImage!),
                      radius: 22,
                    )
                  : const CircleAvatar(
                      backgroundImage: AssetImage('assets/img/user.png'),
                      radius: 22,
                      backgroundColor: AppColors.primaryColor,
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
