import 'package:clinic/features/time_line/model/comment_model.dart';
import 'package:clinic/features/time_line/model/reply_model.dart';
import 'package:clinic/features/time_line/pages/post/comment/react_comment_widget.dart';
import 'package:clinic/features/time_line/pages/post/comment/react_reply_widget.dart';
import 'package:clinic/features/time_line/pages/post/common/doctor_specialization_info_widget.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/data/models/doctor_model.dart';
import 'package:flutter/material.dart';

class CommentBottomWidget extends StatelessWidget {
  const CommentBottomWidget({
    Key? key,
    required this.comment,
    required this.isCommentPage,
    required this.isReply,
  }) : super(key: key);

  final CommentModel comment;
  final bool isCommentPage;
  final bool isReply;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        (comment.writer.userType == UserType.doctor)
            ? DoctorSpecializationInfoWidget(
                specialization:
                    ((comment.writer) as DoctorModel).specialization)
            : const SizedBox(),
        isReply
            ? ReactReplyWidget(reply: comment as ReplyModel)
            : ReactCommentWidget(
                comment: comment,
              ),
      ],
    );
  }
}
