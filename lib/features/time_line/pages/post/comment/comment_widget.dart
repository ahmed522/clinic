import 'package:clinic/features/time_line/model/comment_model.dart';
import 'package:clinic/features/time_line/pages/post/comment/comment_bottom_widget.dart';
import 'package:clinic/features/time_line/pages/post/comment/comment_container.dart';
import 'package:clinic/features/time_line/pages/post/common/post_content_widget.dart';
import 'package:clinic/features/time_line/pages/post/common/post_top_widget.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';

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
    return Padding(
      padding: EdgeInsets.only(
        top: isCommentPage ? 10.0 : 0.0,
        right: isCommentPage ? 8.0 : 25.0,
        left: isCommentPage ? 8.0 : 25.0,
        bottom: 5.0,
      ),
      child: CommentContainer(
        borderWidth: 0.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            PostTopWidget(
              userName: CommonFunctions.getFullName(
                  comment.writer.firstName!, comment.writer.lastName!),
              personalImageURL: comment.writer.personalImageURL!,
              setSideInfo: (comment.writer.userType == UserType.doctor),
              postSideInfoText:
                  (comment.writer.gender == Gender.male) ? 'طبيب' : 'طبيبة',
              postSideInfoTextColor:
                  (Theme.of(context).brightness == Brightness.light)
                      ? AppColors.primaryColor
                      : Colors.white,
              postSideInfoImageAsset: (comment.writer.gender == Gender.male)
                  ? 'assets/img/male-doctor.png'
                  : 'assets/img/female-doctor.png',
              timestamp: comment.commentTime,
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
    );
  }
}
