import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/time_line/controller/comment_reacts_controller.dart';
import 'package:clinic/features/time_line/controller/comment_replies_controller.dart';
import 'package:clinic/features/time_line/model/comment_model.dart';
import 'package:clinic/features/time_line/pages/post/comment/comment_reacts_widget.dart';
import 'package:clinic/features/time_line/pages/post/comment/comment_replies_widget.dart';
import 'package:clinic/features/time_line/pages/post/comment/comment_widget.dart';
import 'package:clinic/features/time_line/pages/post/comment/create_comment/common/create_comment.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/error_page.dart';
import 'package:clinic/global/widgets/offline_page_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentPage extends StatelessWidget {
  const CommentPage(
      {super.key,
      required this.comment,
      required this.postWriterId,
      required this.postWriterType});
  final CommentModel comment;
  final String postWriterId;
  final UserType postWriterType;
  @override
  Widget build(BuildContext context) {
    try {
      final repliesController =
          Get.put(CommentRepliesController(comment.commentId));
      final reactsController = Get.put(CommentReactsController(
          postId: comment.postId, commentId: comment.commentId));
      final size = MediaQuery.of(context).size;
      Gender writerGender = comment.writer.gender;
      String appBarTitleText =
          '${comment.writer.userType == UserType.doctor ? 'تعليق ${(writerGender == Gender.male) ? 'الطبيب ' : 'الطبيبة '}' : 'تعليق '}${CommonFunctions.getFullName(comment.writer.firstName!, comment.writer.lastName!)}';
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_forward),
            ),
          ],
          title: Align(
            alignment: Alignment.centerRight,
            child: Text(
              appBarTitleText,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: AppFonts.mainArabicFontFamily,
                fontWeight: FontWeight.w700,
                fontSize: (size.width < 330) ? 15 : 20,
              ),
            ),
          ),
        ),
        body: OfflinePageBuilder(
          child: RefreshIndicator(
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
        ),
      );
    } catch (e) {
      return const ErrorPage(
        imageAsset: 'assets/img/error.svg',
        message: 'حدثت مشكلة، يرجى إعادة المحاولة',
      );
    }
  }

  Widget getCommentPage(BuildContext context) {
    final AuthenticationController authenticationController =
        AuthenticationController.find;
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          CommentWidget(
            postWriterType: postWriterType,
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
          ((authenticationController.currentUserType == UserType.doctor) ||
                  (authenticationController.currentUserId == postWriterId))
              ? CreateCommentWidget(
                  postId: comment.postId,
                  postWriterId: postWriterId,
                  postWriterType: postWriterType,
                  isReply: true,
                  commentId: comment.commentId,
                  commentWriterId: comment.writer.userId,
                  commentWriterType: comment.writer.userType,
                )
              : const SizedBox(),
          const CommentRepliesWidget(),
        ],
      ),
    );
  }
}
