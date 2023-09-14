import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/features/notifications/controller/notifications_controller.dart';
import 'package:clinic/features/settings/model/post_activity_model.dart';
import 'package:clinic/features/time_line/controller/post_comments_controller.dart';
import 'package:clinic/features/time_line/model/comment_model.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/data/models/parent_user_model.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class CreateCommentController extends GetxController {
  static CreateCommentController get find => Get.find();
  final _authenticationController = AuthenticationController.find;
  final _userDataController = UserDataController.find;
  final _postCommentsController = PostCommentsController.find;
  final textController = TextEditingController();
  uploadComment(
    CommentModel comment,
    String postWriterId,
    UserType postWriterType,
  ) async {
    String commentDocumentId = '${comment.postId}-${const Uuid().v4()}';
    comment.commentId = commentDocumentId;
    try {
      final DocumentReference postCommentsDocument =
          _getCommentDocumentById(comment.postId, commentDocumentId);
      await postCommentsDocument.set(comment.toJson());
      MySnackBar.showGetSnackbar('تم نشر تعليقك بنجاح', Colors.green);
      NotificationsController.find.notifyComment(
        postWriterId: postWriterId,
        commentedComponent: 'comment',
        postId: comment.postId,
        commentId: comment.commentId,
      );
      await _loadComments(comment.postId);

      String postWriterName = (postWriterId == currentUserId)
          ? currentUserName
          : await _userDataController.getUserNameById(
              postWriterId, postWriterType);
      Gender postWriterGender = (postWriterId == currentUserId)
          ? currentUserGender
          : await _userDataController.getUserGenderById(
              postWriterId, postWriterType);
      PostActivityModel postActivity = PostActivityModel(
        postId: comment.postId,
        postWriterId: postWriterId,
        postWriterName: postWriterName,
        postWriterType: postWriterType,
        postWriterGender: postWriterGender,
        activityTime: comment.commentTime,
      );
      _userDataController.uploadUserCommentPostActivity(
          currentUserId, commentDocumentId, postActivity);
    } catch (error) {
      CommonFunctions.errorHappened();
    }
  }

  _getCommentDocumentById(String postId, String commentDocumentId) =>
      _userDataController.getCommentDocumentById(postId, commentDocumentId);

  _loadComments(String postId) =>
      _postCommentsController.loadPostComments(3, true);

  String get currentUserId => _authenticationController.currentUserId;
  String get currentUserName => _authenticationController.currentUserName;
  String? get currentUserPersonalImage =>
      _authenticationController.currentUserPersonalImage;
  UserType get currentUserType => _authenticationController.currentUserType;
  Gender get currentUserGender => _authenticationController.currentUserGender;
  ParentUserModel get currentUser => _authenticationController.currentUser;
}
