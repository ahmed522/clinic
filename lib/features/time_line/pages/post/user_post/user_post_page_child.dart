import 'package:clinic/features/time_line/controller/post_comments_controller.dart';
import 'package:clinic/features/time_line/model/user_post_model.dart';
import 'package:clinic/features/time_line/pages/post/comment/create_comment/common/create_comment.dart';
import 'package:clinic/features/time_line/pages/post/user_post/user_post_widget.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserPostPageChild extends StatelessWidget {
  const UserPostPageChild({
    Key? key,
    required this.post,
  }) : super(key: key);

  final UserPostModel post;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      PostCommentsController(post.postId!),
    );
    return RefreshIndicator(
      onRefresh: () => controller.loadPostComments(post.postId!),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            UserPostWidget(
              post: post,
              isPostPage: true,
            ),
            Text(
              'التعليقات',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            CreateCommentWidget(postId: post.postId!),
            GetX<PostCommentsController>(
              builder: (controller) {
                if (controller.loading.isTrue) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: CircularProgressIndicator(
                      color: (Theme.of(context).brightness == Brightness.light)
                          ? AppColors.primaryColor
                          : Colors.white,
                    ),
                  );
                }
                return Column(
                  children: controller.comments.toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
