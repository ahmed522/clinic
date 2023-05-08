import 'package:clinic/features/time_line/controller/post_comments_controller.dart';
import 'package:clinic/features/time_line/model/comment_model.dart';
import 'package:clinic/features/time_line/pages/post/common/react_icon.dart';
import 'package:flutter/material.dart';

class ReactCommentButton extends StatelessWidget {
  const ReactCommentButton({
    Key? key,
    required this.comment,
  }) : super(key: key);
  final CommentModel comment;
  @override
  Widget build(BuildContext context) {
    final controller = PostCommentsController.find;
    return StatefulBuilder(builder: (context, setState) {
      return IconButton(
        iconSize: 20,
        padding: EdgeInsets.zero,
        onPressed: () {
          if (comment.reacted) {
            controller.unReactComment(comment.postId, comment.commentId);
            setState(
              () => comment.reacted = false,
            );
          } else {
            controller.reactComment(comment.postId, comment.commentId);
            setState(
              () => comment.reacted = true,
            );
          }
        },
        icon: ReactIcon(
          reacted: comment.reacted,
        ),
      );
    });
  }
}
