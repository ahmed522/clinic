import 'package:clinic/features/time_line/controller/post_comments_controller.dart';
import 'package:clinic/features/time_line/model/comment_model.dart';
import 'package:clinic/features/time_line/pages/post/common/react_icon.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:clinic/global/widgets/present_number_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReactCommentWidget extends StatelessWidget {
  const ReactCommentWidget({
    Key? key,
    required this.comment,
  }) : super(key: key);

  final CommentModel comment;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostCommentsController>(
      builder: (controller) {
        return Row(
          children: [
            PresentNumberWidget(number: comment.reacts, fontSize: 10),
            comment.loading
                ? const Padding(
                    padding: EdgeInsets.only(
                        right: 20.0, left: 10, bottom: 20, top: 20),
                    child: AppCircularProgressIndicator(width: 10, height: 10),
                  )
                : IconButton(
                    iconSize: 20,
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      if (comment.reacted) {
                        comment.loading = true;
                        controller.update();
                        await controller.unReactComment(
                          comment.postId,
                          comment.commentId,
                        );
                        --comment.reacts;
                        comment.reacted = false;
                        comment.loading = false;
                        controller.update();
                      } else {
                        comment.loading = true;
                        controller.update();
                        await controller.reactComment(
                          comment.postId,
                          comment.commentId,
                          comment.writer.userId!,
                        );
                        ++comment.reacts;
                        comment.reacted = true;
                        comment.loading = false;
                        controller.update();
                      }
                    },
                    icon: ReactIcon(
                      reacted: comment.reacted,
                    ),
                  ),
          ],
        );
      },
    );
  }
}
