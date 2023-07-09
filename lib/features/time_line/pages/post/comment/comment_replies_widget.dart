import 'package:clinic/features/time_line/controller/comment_replies_controller.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentRepliesWidget extends StatelessWidget {
  const CommentRepliesWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<CommentRepliesController>(
      builder: (controller) {
        if (controller.loading.isTrue) {
          return const Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: AppCircularProgressIndicator(
              width: 50,
              height: 50,
            ),
          );
        }
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: controller.replies.length,
          itemBuilder: (context, index) => controller.replies[index],
        );
      },
    );
  }
}
