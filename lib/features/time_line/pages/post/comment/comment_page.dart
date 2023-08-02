import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/time_line/controller/comment_reacts_controller.dart';
import 'package:clinic/features/time_line/controller/comment_replies_controller.dart';
import 'package:clinic/features/time_line/model/comment_model.dart';
import 'package:clinic/features/time_line/pages/post/comment/comment_reacts_widget.dart';
import 'package:clinic/features/time_line/pages/post/comment/comment_replies_widget.dart';
import 'package:clinic/features/time_line/pages/post/comment/comment_widget.dart';
import 'package:clinic/features/time_line/pages/post/comment/create_comment/common/create_comment.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentPage extends StatelessWidget {
  const CommentPage({super.key, required this.comment});
  final CommentModel comment;
  @override
  Widget build(BuildContext context) {
    final repliesController =
        Get.put(CommentRepliesController(comment.commentId));
    final reactsController = Get.put(CommentReactsController(
        postId: comment.postId, commentId: comment.commentId));

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              CommonFunctions.getFullName(
                  comment.writer.firstName!, comment.writer.lastName!),
              style: const TextStyle(
                fontFamily: AppFonts.mainArabicFontFamily,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            Text(
              comment.writer.userType == UserType.doctor
                  ? ' تعليق الطبيب'
                  : ' تعليق',
              style: const TextStyle(
                fontFamily: AppFonts.mainArabicFontFamily,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        child: getCommentPage(context),
        onRefresh: () async {
          if (reactsController.loading.isFalse &&
              reactsController.moreReactsloading.isFalse) {
            reactsController.loadCommentReacts(1, true);
          }
          if (repliesController.loading.isFalse &&
              repliesController.moreRepliesloading.isFalse) {
            repliesController.loadCommentReplies(2, true);
          }
        },
      ),
    );
  }

  Widget getCommentPage(BuildContext context) {
    final AuthenticationController authenticationController =
        AuthenticationController.find;
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          CommentWidget(
            comment: comment,
            isCommentPage: true,
          ),
          const CommentReactsWidget(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              'الردود',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          (comment.writer.userType == UserType.doctor)
              ? (authenticationController.currentUserType == UserType.doctor)
                  ? CreateCommentWidget(
                      postId: comment.postId,
                      isReply: true,
                      commentId: comment.commentId,
                    )
                  : const SizedBox()
              : ((authenticationController.currentUserType ==
                          UserType.doctor) ||
                      (authenticationController.currentUserId ==
                          comment.writer.userId))
                  ? CreateCommentWidget(
                      postId: comment.postId,
                      isReply: true,
                      commentId: comment.commentId,
                    )
                  : const SizedBox(),
          const CommentRepliesWidget(),
        ],
      ),
    );
  }
}
