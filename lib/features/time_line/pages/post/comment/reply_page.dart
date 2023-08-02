import 'package:clinic/features/time_line/controller/reply_reacts_controller.dart';
import 'package:clinic/features/time_line/model/reply_model.dart';
import 'package:clinic/features/time_line/pages/post/comment/comment_widget.dart';
import 'package:clinic/features/time_line/pages/post/comment/reply_reacts_widget.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReplyPage extends StatelessWidget {
  const ReplyPage({super.key, required this.reply});
  final ReplyModel reply;
  @override
  Widget build(BuildContext context) {
    final reactsController = Get.put(ReplyReactsController(
        commentId: reply.commentId, replyId: reply.replyId));
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              CommonFunctions.getFullName(
                  reply.writer.firstName!, reply.writer.lastName!),
              style: const TextStyle(
                fontFamily: AppFonts.mainArabicFontFamily,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            Text(
              reply.writer.userType == UserType.doctor ? ' رد الطبيب' : ' رد',
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
        child: getReplyPage(context),
        onRefresh: () async {
          if (reactsController.loading.isFalse &&
              reactsController.moreReactsloading.isFalse) {
            reactsController.loadReplyReacts(3, true);
          }
        },
      ),
    );
  }

  Widget getReplyPage(BuildContext context) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            CommentWidget(
              comment: reply,
              isCommentPage: true,
              isReply: true,
            ),
            const ReplyReactsWidget(),
          ],
        ),
      );
}
