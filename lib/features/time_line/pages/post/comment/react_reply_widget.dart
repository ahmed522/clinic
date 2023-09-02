import 'package:clinic/features/time_line/controller/comment_replies_controller.dart';
import 'package:clinic/features/time_line/model/reply_model.dart';
import 'package:clinic/features/time_line/pages/post/common/react_icon.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:clinic/global/widgets/present_number_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReactReplyWidget extends StatelessWidget {
  const ReactReplyWidget({
    Key? key,
    required this.reply,
  }) : super(key: key);
  final ReplyModel reply;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommentRepliesController>(
      builder: (controller) {
        return Row(
          children: [
            PresentNumberWidget(number: reply.reacts, fontSize: 10),
            reply.loading
                ? const Padding(
                    padding: EdgeInsets.only(right: 20.0, left: 10, bottom: 10),
                    child: AppCircularProgressIndicator(width: 10, height: 10),
                  )
                : IconButton(
                    iconSize: 20,
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      if (reply.reacted) {
                        reply.loading = true;
                        controller.update();
                        await controller.unReactReply(
                            reply.commentId, reply.replyId);
                        --reply.reacts;
                        reply.reacted = false;
                        reply.loading = false;
                        controller.update();
                      } else {
                        reply.loading = true;
                        controller.update();
                        await controller.reactReply(
                          reply.commentId,
                          reply.replyId,
                          reply.writer.userId!,
                          reply.postId,
                        );
                        ++reply.reacts;
                        reply.reacted = true;
                        reply.loading = false;
                        controller.update();
                      }
                    },
                    icon: ReactIcon(
                      reacted: reply.reacted,
                    ),
                  ),
          ],
        );
      },
    );
  }
}
