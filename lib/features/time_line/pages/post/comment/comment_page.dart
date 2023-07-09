import 'package:clinic/features/time_line/controller/comment_replies_controller.dart';
import 'package:clinic/features/time_line/model/comment_model.dart';
import 'package:clinic/features/time_line/pages/post/comment/comment_replies_widget.dart';
import 'package:clinic/features/time_line/pages/post/comment/comment_widget.dart';
import 'package:clinic/features/time_line/pages/post/comment/create_comment/common/create_comment.dart';
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
            const Text(
              ' تعليق',
              style: TextStyle(
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
        onRefresh: () =>
            repliesController.loadCommentReplies(comment.commentId),
      ),
    );
  }

  Widget getCommentPage(BuildContext context) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            CommentWidget(
              comment: comment,
              isCommentPage: true,
            ),
            CreateCommentWidget(
              postId: comment.postId,
              isReply: true,
              commentId: comment.commentId,
            ),
            const CommentRepliesWidget(),
          ],
        ),
      );
}
