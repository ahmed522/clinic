import 'package:clinic/features/time_line/controller/post_comments_controller.dart';
import 'package:clinic/features/time_line/controller/post_reacts_controller.dart';
import 'package:clinic/features/time_line/model/doctor_post_model.dart';
import 'package:clinic/features/time_line/model/parent_post_model.dart';
import 'package:clinic/features/time_line/model/user_post_model.dart';
import 'package:clinic/features/time_line/pages/post/common/post_reacts_widget.dart';
import 'package:clinic/features/time_line/pages/post/doctor_post/doctor_post_widget.dart';
import 'package:clinic/features/time_line/pages/post/common/post_comments_widget.dart';
import 'package:clinic/features/time_line/pages/post/user_post/user_post_widget.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostPageChild extends StatelessWidget {
  const PostPageChild({
    Key? key,
    required this.post,
    required this.writerType,
  }) : super(key: key);

  final ParentPostModel post;
  final UserType writerType;

  @override
  Widget build(BuildContext context) {
    final commentsController = Get.put(
      PostCommentsController(post.postId!),
    );
    final reactsController = Get.put(
      PostReactsController(postId: post.postId!),
    );

    return RefreshIndicator(
      onRefresh: () async {
        if (reactsController.loading.isFalse &&
            reactsController.moreReactsloading.isFalse) {
          reactsController.loadPostReacts(1, true);
        }
        if (commentsController.loading.isFalse &&
            commentsController.moreCommentsloading.isFalse) {
          commentsController.loadPostComments(2, true);
        }
      },
      child: buildUserPostPage(context),
    );
  }

  SingleChildScrollView buildUserPostPage(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          (writerType == UserType.user)
              ? UserPostWidget(
                  post: post as UserPostModel,
                  isPostPage: true,
                )
              : DoctorPostWidget(
                  post: post as DoctorPostModel,
                  isClickable: false,
                  isProfilePage: true,
                ),
          const PostReactsWidget(),
          PostCommentsWidget(post: post, writerType: writerType),
        ],
      ),
    );
  }
}
