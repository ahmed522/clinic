import 'package:clinic/features/time_line/controller/reply_reacts_controller.dart';
import 'package:clinic/features/time_line/model/reply_model.dart';
import 'package:clinic/features/time_line/pages/post/comment/comment_widget.dart';
import 'package:clinic/features/time_line/pages/post/comment/reply_reacts_widget.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/offline_page_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReplyPage extends StatelessWidget {
  const ReplyPage({super.key, required this.reply});
  final ReplyModel reply;
  @override
  Widget build(BuildContext context) {
    final reactsController = Get.put(ReplyReactsController(
        commentId: reply.commentId, replyId: reply.replyId));
    final size = MediaQuery.of(context).size;
    String appBarTitleText =
        '${reply.writer.userType == UserType.doctor ? ' رد الطبيب' : ' رد'} ${CommonFunctions.getFullName(reply.writer.firstName!, reply.writer.lastName!)}';
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(
            appBarTitleText,
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
          child: getReplyPage(context),
          onRefresh: () async {
            if (reactsController.loading.isFalse &&
                reactsController.moreReactsloading.isFalse) {
              reactsController.loadReplyReacts(3, true);
            }
          },
        ),
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
