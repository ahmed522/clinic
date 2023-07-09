import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/features/time_line/model/comment_model.dart';
import 'package:clinic/features/time_line/pages/post/comment/comment_widget.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/data/models/parent_user_model.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:clinic/global/widgets/error_page.dart';
import 'package:clinic/global/widgets/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostCommentsController extends GetxController {
  static PostCommentsController get find => Get.find();
  final _authenticationController = AuthenticationController.find;
  final _userDataController = UserDataController.find;
  RxList<CommentWidget> comments = <CommentWidget>[].obs;
  late String postId;
  RxBool loading = false.obs;

  PostCommentsController(this.postId);
  @override
  void onReady() {
    loadPostComments(postId);
    super.onReady();
  }

  Future loadPostComments(String postId) async {
    loading.value = true;
    try {
      QuerySnapshot snapshot = await _getPostCommentsCollectionById(postId)
          .orderBy('comment_time', descending: false)
          .get();
      if (snapshot.size == 0) {
        loading.value = false;
        return;
      }
      _showPostComments(snapshot);
    } catch (e) {
      loading.value = false;
      Get.off(() => const ErrorPage(
            imageAsset: 'assets/img/error.svg',
            message:
                'حدثت مشكلة نعمل على حلها الان، يرجى إعادة المحاولة لاحقاً',
          ));
    }
  }

  reactComment(String postDocumentId, String commentDocumentId) async {
    _getCommentReactsCollectionById(postDocumentId, commentDocumentId)
        .doc(_authenticationController.currentUser!.userId!)
        .set({'reacted': true});
    await _updateCommentReacts(postDocumentId, commentDocumentId, true);
  }

  unReactComment(String postDocumentId, String commentDocumentId) async {
    _getCommentReactsCollectionById(postDocumentId, commentDocumentId)
        .doc(_authenticationController.currentUser!.userId!)
        .delete();
    await _updateCommentReacts(postDocumentId, commentDocumentId, false);
  }

  CollectionReference _getPostCommentsCollectionById(String postId) =>
      _userDataController.getPostCommentsCollectionById(postId);

  Future<void> _showPostComments(QuerySnapshot<Object?> snapshot) async {
    comments.clear();

    for (var commentSnapshot in snapshot.docs) {
      final String uid = commentSnapshot.get('uid');
      final UserType userType = commentSnapshot.get('writer_type') == 'doctor'
          ? UserType.doctor
          : UserType.user;
      final ParentUserModel writer;
      if (userType == UserType.doctor) {
        writer = await _userDataController.getDoctorById(uid);
      } else {
        writer = await _userDataController.getUserById(uid);
      }
      CommentModel comment = CommentModel.fromSnapshot(
        commentSnapshot:
            commentSnapshot as DocumentSnapshot<Map<String, dynamic>>,
        writer: writer,
      );
      comment.reacted = await _userDataController.isUserReactedComment(
          _authenticationController.currentUser!.userId!,
          comment.postId,
          comment.commentId);
      loading.value = false;
      comments.add(CommentWidget(comment: comment));
    }
  }

  onCommentSettingsButtonPressed(BuildContext context, String commentId) {
    Get.bottomSheet(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: () => MyAlertDialog.showAlertDialog(
              context,
              'حذف التعليق',
              'هل انت متأكد من حذف هذا التعليق؟',
              MyAlertDialog.getAlertDialogActions(
                {
                  'نعم': () async {
                    try {
                      loading.value = true;
                      Get.back(closeOverlays: true);
                      await _deleteCommentById(postId, commentId)
                          .whenComplete(() async {
                        Get.back();
                        await loadPostComments(postId).then((value) =>
                            MySnackBar.showGetSnackbar(
                                'تم حذف التعليق بنجاح', Colors.green));
                      });
                    } catch (e) {
                      Get.back();
                      CommonFunctions.errorHappened();
                    }
                  },
                  'إلغاء': () => Get.back(),
                },
              ),
            ),
            title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'حذف التعليق',
                style: TextStyle(
                  color: (Theme.of(context).brightness == Brightness.dark)
                      ? Colors.white
                      : AppColors.darkThemeBackgroundColor,
                  fontFamily: AppFonts.mainArabicFontFamily,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            trailing: const Icon(Icons.delete_rounded),
          ),
        ],
      ),
      backgroundColor: CommonFunctions.isLightMode(context)
          ? Colors.white
          : AppColors.darkThemeBottomNavBarColor,
    );
  }

  _deleteCommentById(String postDocumentId, String commentId) async =>
      _userDataController.deleteCommentById(postDocumentId, commentId);
  CollectionReference _getCommentReactsCollectionById(
          String postDocumentId, String commentDocumentId) =>
      _getCommentDocumentRefById(postDocumentId, commentDocumentId)
          .collection('comment_reacts');

  _updateCommentReacts(
      String postDocumentId, String commentDocumentId, bool plus) async {
    int factor = -1;
    if (plus) {
      factor = 1;
    }
    int oldReacts =
        await _getCommentReactsById(postDocumentId, commentDocumentId);
    await _getCommentDocumentRefById(postDocumentId, commentDocumentId)
        .update({'reacts': oldReacts + factor});
  }

  Future<int> _getCommentReactsById(
      String postDocumentId, String commentDocumentId) async {
    int? reacts;
    await _getCommentDocumentRefById(postDocumentId, commentDocumentId)
        .get()
        .then((value) {
      final data = value.data() as Map<String, dynamic>;
      reacts = data['reacts'];
    });
    return reacts!;
  }

  _getCommentDocumentRefById(String postDocumentId, String commentDocumentId) =>
      _userDataController.getCommentDocumentById(
          postDocumentId, commentDocumentId);

  bool isCurrentUserComment(String uid) => (uid == _currentUserId);

  get _currentUserId => _authenticationController.currentUserId;
}
