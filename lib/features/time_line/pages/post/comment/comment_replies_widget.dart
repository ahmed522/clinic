import 'package:clinic/features/time_line/controller/comment_replies_controller.dart';
import 'package:clinic/features/time_line/pages/post/comment/comment_widget.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:clinic/global/widgets/containered_text.dart';
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
        if (controller.replies.isEmpty) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 20.0),
            child: ContaineredText(
              text: 'لا توجد ردود حتى الان',
            ),
          );
        }

        return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: controller.replies.length,
            itemBuilder: (context, index) {
              if (index == controller.replies.length - 1) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Column(
                    children: [
                      CommentWidget(
                        comment: controller.replies[index],
                        isReply: true,
                      ),
                      GetX<CommentRepliesController>(
                        builder: (controller) {
                          if (controller.noMoreReplies.isTrue) {
                            return const SizedBox();
                          }
                          if (controller.moreRepliesloading.isTrue) {
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
                                      controller.loadCommentReplies(3, false),
                                  child: Text(
                                    'المزيد',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  )),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }
              return CommentWidget(
                comment: controller.replies[index],
                isReply: true,
              );
            });
      },
    );
  }
}
