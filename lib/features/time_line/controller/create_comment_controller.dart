import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/features/time_line/controller/post_comments_controller.dart';
import 'package:clinic/features/time_line/model/comment_model.dart';
import 'package:clinic/global/data/models/parent_user_model.dart';
import 'package:clinic/global/widgets/error_page.dart';
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
  uploadComment(CommentModel comment) async {
    String commentDocumentId = '${comment.postId}-${const Uuid().v4()}';
    comment.commentId = commentDocumentId;

    final DocumentReference postCommentsDocument =
        _getCommentDocumentById(comment.postId, commentDocumentId);
    await postCommentsDocument.set(comment.toJson()).whenComplete(() async {
      await _loadComments(comment.postId);
      MySnackBar.showGetSnackbar('تم نشر تعليقك بنجاح', Colors.green);
    }).catchError(
      (error) => Get.to(
        () => const ErrorPage(
          imageAsset: 'assets/img/error.svg',
          message: '  حدثت مشكلة، يرجى إعادة المحاولة لاحقاً',
        ),
      ),
    );
  }

  _getCommentDocumentById(String postId, String commentDocumentId) =>
      _userDataController.getCommentDocumentById(postId, commentDocumentId);

  _loadComments(String postId) =>
      _postCommentsController.loadPostComments(3, true);

  String get currentUserId => _authenticationController.currentUserId;
  String get currentUserName => _authenticationController.currentUserName;
  String? get currentUserPersonalImage =>
      _authenticationController.currentUserPersonalImage;
  ParentUserModel get currentUser => _authenticationController.currentUser;
}
