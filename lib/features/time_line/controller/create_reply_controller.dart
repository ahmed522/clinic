import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/features/time_line/controller/comment_replies_controller.dart';
import 'package:clinic/features/time_line/model/reply_model.dart';
import 'package:clinic/global/functions/common_functions.dart';
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
    final DocumentReference commentrepliesDocument =
        _getCommentRepliesDocumentById(reply.commentId, replyDocumentId);
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

  getCurrentUserName() => CommonFunctions.getFullName(
      _authenticationController.currentUser!.firstName!,
      _authenticationController.currentUser!.lastName!);
  getCurrentUserPic() =>
      _authenticationController.currentUser!.personalImageURL;
  getCurrentUserId() => _authenticationController.currentUser!.userId;
  getCurrentUser() => _authenticationController.currentUser!;
  _getCommentRepliesDocumentById(String commentId, String replyDocumentId) =>
      _userDataController.getReplyDocumentById(commentId, replyDocumentId);
  _loadReplies(String commentId) =>
      _commentRepliesController.loadCommentReplies(commentId);
}
