import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/features/notifications/controller/notifications_controller.dart';
import 'package:clinic/features/settings/model/comment_activity_model.dart';
import 'package:clinic/features/time_line/controller/comment_replies_controller.dart';
import 'package:clinic/features/time_line/model/reply_model.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/data/models/parent_user_model.dart';
import 'package:clinic/global/functions/common_functions.dart';
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
  uploadReply(
    ReplyModel reply,
    String commentWriterId,
    UserType commentWriterType,
    String postWriterId,
    UserType postWriterType,
  ) async {
    String replyDocumentId = '${reply.commentId}-${const Uuid().v4()}';
    reply.replyId = replyDocumentId;
    try {
      await _getCommentRepliesDocumentById(reply.commentId)
          .set({'post_id': reply.postId});
      final DocumentReference commentrepliesDocument =
          _getReplyDocumentById(reply.commentId, replyDocumentId);
      await commentrepliesDocument.set(reply.toJson());
      NotificationsController.find.notifyComment(
        postWriterId: postWriterId,
        commentWriterId: commentWriterId,
        commentedComponent: 'reply',
        postId: reply.postId,
        commentId: reply.commentId,
        replyId: reply.replyId,
      );
      await _loadReplies(reply.commentId);
      MySnackBar.showGetSnackbar('تم نشر ردك بنجاح', Colors.green);
      String postWriterName = (postWriterId == currentUserId)
          ? currentUserName
          : await _userDataController.getUserNameById(
              postWriterId, postWriterType);
      Gender postWriterGender = (postWriterId == currentUserId)
          ? currentUserGender
          : await _userDataController.getUserGenderById(
              postWriterId, postWriterType);
      String commentWriterName = (commentWriterId == currentUserId)
          ? currentUserName
          : await _userDataController.getUserNameById(
              commentWriterId, commentWriterType);
      Gender commentWriterGender = (commentWriterId == currentUserId)
          ? currentUserGender
          : await _userDataController.getUserGenderById(
              commentWriterId, commentWriterType);
      CommentActivityModel commentActivity = CommentActivityModel(
        postId: reply.postId,
        commentId: reply.commentId,
        commentWriterId: commentWriterId,
        commentWriterName: commentWriterName,
        commentWriterType: commentWriterType,
        commentWriterGender: commentWriterGender,
        activityTime: reply.commentTime,
      );
      commentActivity.postWriterId = postWriterId;
      commentActivity.postWriterName = postWriterName;
      commentActivity.postWriterType = postWriterType;
      commentActivity.postWriterGender = postWriterGender;
      await _userDataController.uploadUserReplyCommentActivity(
        currentUserId,
        reply.replyId,
        commentActivity,
      );
    } catch (e) {
      CommonFunctions.errorHappened();
    }
  }

  String get currentUserId => _authenticationController.currentUserId;
  String get currentUserName => _authenticationController.currentUserName;
  UserType get currentUserType => _authenticationController.currentUserType;

  String? get currentUserPersonalImage =>
      _authenticationController.currentUserPersonalImage;
  Gender get currentUserGender => _authenticationController.currentUserGender;
  ParentUserModel get currentUser => _authenticationController.currentUser;
  _getReplyDocumentById(String commentId, String replyDocumentId) =>
      _userDataController.getReplyDocumentById(commentId, replyDocumentId);
  DocumentReference _getCommentRepliesDocumentById(String commentId) =>
      _userDataController.getCommentRepliesDocumentById(commentId);
  _loadReplies(String commentId) =>
      _commentRepliesController.loadCommentReplies(3, true);
}
