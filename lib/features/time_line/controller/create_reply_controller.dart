import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/features/time_line/controller/comment_replies_controller.dart';
import 'package:clinic/features/time_line/model/reply_model.dart';
import 'package:clinic/global/widgets/error_page.dart';
import 'package:clinic/global/widgets/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class CreateReplyController extends GetxController {
  static CreateReplyController get find => Get.find();
  final _authenticationController = AuthenticationController.find;
  final _userDataController = UserDataController.find;
  final _commentRepliesController = CommentRepliesController.find;
  final textController = TextEditingController();
  uploadReply(ReplyModel reply) async {
    String replyDocumentId = '${reply.commentId}-${const Uuid().v4()}';
    reply.replyId = replyDocumentId;
    await _getCommentRepliesDocumentById(reply.commentId)
        .set({'post_id': reply.postId});
    final DocumentReference commentrepliesDocument =
        _getReplyDocumentById(reply.commentId, replyDocumentId);
    await commentrepliesDocument.set(reply.toJson()).whenComplete(() async {
      await _loadReplies(reply.commentId);
      MySnackBar.showGetSnackbar('تم نشر ردك بنجاح', Colors.green);
    }).catchError(
      (error) => Get.to(
        () => const ErrorPage(
          imageAsset: 'assets/img/error.svg',
          message: '  حدثت مشكلة، يرجى إعادة المحاولة لاحقاً',
        ),
      ),
    );
  }

  getCurrentUserName() => _authenticationController.currentUserName;
  getCurrentUserPic() => _authenticationController.currentUserPersonalImage;
  getCurrentUserId() => _authenticationController.currentUserId;
  getCurrentUser() => _authenticationController.currentUser;
  _getReplyDocumentById(String commentId, String replyDocumentId) =>
      _userDataController.getReplyDocumentById(commentId, replyDocumentId);
  DocumentReference _getCommentRepliesDocumentById(String commentId) =>
      _userDataController.getCommentRepliesDocumentById(commentId);
  _loadReplies(String commentId) =>
      _commentRepliesController.loadCommentReplies(3, true);
}
