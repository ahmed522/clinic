import 'package:clinic/features/time_line/controller/post_comments_controller.dart';
import 'package:clinic/features/time_line/model/parent_post_model.dart';
import 'package:clinic/features/time_line/model/user_post_model.dart';
import 'package:clinic/features/time_line/pages/post/comment/comment_widget.dart';
import 'package:clinic/features/time_line/pages/post/comment/create_comment/common/create_comment.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostCommentsWidget extends StatelessWidget {
  const PostCommentsWidget({
    Key? key,
    required this.post,
    required this.writerType,
  }) : super(key: key);
  final ParentPostModel post;
  final UserType writerType;
  @override
  Widget build(BuildContext context) {
    final PostCommentsController controller = PostCommentsController.find;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Text(
            'التعليقات',
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
        (writerType == UserType.doctor)
            ? (controller.currentUserType == UserType.doctor)
                ? CreateCommentWidget(postId: post.postId!)
                : const SizedBox()
            : ((controller.currentUserType == UserType.doctor) ||
                    (controller.isCurrentUserComment(
                        (post as UserPostModel).user.userId!)))
                ? CreateCommentWidget(postId: post.postId!)
                : const SizedBox(),
        GetX<PostCommentsController>(
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
              itemCount: controller.comments.length,
              itemBuilder: (context, index) {
                if (index == controller.comments.length - 1) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Column(
                      children: [
                        CommentWidget(comment: controller.comments[index]),
                        GetX<PostCommentsController>(
                          builder: (controller) {
                            if (controller.noMoreComments.isTrue) {
                              return const SizedBox();
                            }
                            if (controller.moreCommentsloading.isTrue) {
                              return const Padding(
                                padding: EdgeInsets.only(top: 20.0),
                                child: AppCircularProgressIndicator(
                                  width: 50,
                                  height: 50,
                                ),
                              );
                            }
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: ElevatedButton(
                                    onPressed: () =>
                                        controller.loadPostComments(3, false),
                                    child: Text(
                                      'المزيد',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    )),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  );
                }
                return CommentWidget(comment: controller.comments[index]);
              },
            );
          },
        ),
      ],
    );
  }
}
