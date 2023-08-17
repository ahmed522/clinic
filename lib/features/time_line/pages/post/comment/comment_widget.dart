import 'package:clinic/features/time_line/controller/comment_replies_controller.dart';
import 'package:clinic/features/time_line/controller/post_comments_controller.dart';
import 'package:clinic/features/time_line/model/comment_model.dart';
import 'package:clinic/features/time_line/model/reply_model.dart';
import 'package:clinic/features/time_line/pages/post/comment/comment_bottom_widget.dart';
import 'package:clinic/features/time_line/pages/post/comment/comment_container.dart';
import 'package:clinic/features/time_line/pages/post/comment/comment_page.dart';
import 'package:clinic/features/time_line/pages/post/comment/reply_page.dart';
import 'package:clinic/features/time_line/pages/post/common/post_content_widget.dart';
import 'package:clinic/features/time_line/pages/post/common/post_top_widget.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentWidget extends StatelessWidget {
  final CommentModel comment;
  final bool isCommentPage;
  final bool isReply;
  const CommentWidget({
    super.key,
    required this.comment,
    this.isCommentPage = false,
    this.isReply = false,
  });
  @override
  Widget build(BuildContext context) {
    final controller =
        isReply ? CommentRepliesController.find : PostCommentsController.find;
    return GestureDetector(
      onTap: () => _onCommentPressed(),
      child: Padding(
        padding: EdgeInsets.only(
          top: isCommentPage ? 10.0 : 0.0,
          right: isCommentPage ? 8.0 : 15.0,
          left: isCommentPage ? 8.0 : 15.0,
          bottom: 3.0,
        ),
        child: CommentContainer(
          borderWidth: 0.2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              PostTopWidget(
                userName: CommonFunctions.getFullName(
                    comment.writer.firstName!, comment.writer.lastName!),
                userId: comment.writer.userId!,
                userType: comment.writer.userType,
                isCurrentUserPost: isReply
                    ? (controller as CommentRepliesController)
                        .isCurrentUserReply(comment.writer.userId!)
                    : (controller as PostCommentsController)
                        .isCurrentUserComment(comment.writer.userId!),
                personalImageURL: comment.writer.personalImageURL,
                setSideInfo: (comment.writer.userType == UserType.doctor),
                postSideInfoText:
                    (comment.writer.gender == Gender.male) ? 'طبيب' : 'طبيبة',
                postSideInfoTextColor: (CommonFunctions.isLightMode(context))
                    ? AppColors.primaryColor
                    : Colors.white,
                postSideInfoImageAsset: (comment.writer.gender == Gender.male)
                    ? 'assets/img/male-doctor.png'
                    : 'assets/img/female-doctor.png',
                timestamp: comment.commentTime,
                paddingValue: isCommentPage ? 26 : 10,
                onSettingsButtonPressed: () => isReply
                    ? (controller as CommentRepliesController)
                        .onReplySettingsButtonPressed(
                            context, (comment as ReplyModel).replyId)
                    : (controller as PostCommentsController)
                        .onCommentSettingsButtonPressed(
                            context, comment.commentId),
                isProfilePage: false,
              ),
              const SizedBox(
                height: 10,
              ),
              PostContentWidget(postContent: comment.comment),
              CommentBottomWidget(
                comment: comment,
                isCommentPage: isCommentPage,
                isReply: isReply,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onCommentPressed() {
    if (isCommentPage) {
      return;
    }
    if (isReply) {
      Get.to(() => ReplyPage(reply: comment as ReplyModel));
    } else {
      Get.to(() => CommentPage(comment: comment));
    }
  }
}
