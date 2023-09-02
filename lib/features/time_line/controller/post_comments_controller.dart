import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/features/following/model/follower_model.dart';
import 'package:clinic/features/notifications/controller/notifications_controller.dart';
import 'package:clinic/features/time_line/model/comment_model.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/constants/gender.dart';
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
  RxList<CommentModel> comments = <CommentModel>[].obs;
  late String postId;
  DocumentSnapshot? _lastShowenComment;
  RxBool loading = false.obs;
  RxBool noMoreComments = false.obs;
  RxBool moreCommentsloading = false.obs;

  PostCommentsController(this.postId);
  @override
  void onReady() {
    loadPostComments(2, true);
    super.onReady();
  }

  Future loadPostComments(int limit, bool isRefresh) async {
    if (isRefresh) {
      loading.value = true;
    }
    moreCommentsloading.value = true;

    try {
      QuerySnapshot snapshot;
      if (isRefresh) {
        snapshot = await _getPostCommentsCollectionById(postId)
            .orderBy('comment_time', descending: false)
            .limit(limit)
            .get();
      } else {
        snapshot = await _getPostCommentsCollectionById(postId)
            .orderBy('comment_time', descending: false)
            .startAfterDocument(_lastShowenComment!)
            .limit(limit)
            .get();
      }
      if (snapshot.size < limit) {
        noMoreComments.value = true;
      } else {
        noMoreComments.value = false;
      }

      _showPostComments(snapshot, isRefresh);
    } catch (e) {
      loading.value = false;
      moreCommentsloading.value = false;
      Get.off(() => const ErrorPage(
            imageAsset: 'assets/img/error.svg',
            message:
                'حدثت مشكلة نعمل على حلها الان، يرجى إعادة المحاولة لاحقاً',
          ));
    }
  }

  reactComment(String postDocumentId, String commentDocumentId,
      String commentWriterId) async {
    FollowerModel reacter = FollowerModel(
      userType: currentUserType,
      userId: currentUserId,
      userName: currentUserName,
      doctorGender:
          (currentUserType == UserType.doctor) ? currentUserGender : null,
      doctorSpecialization: (currentUserType == UserType.doctor)
          ? currentDoctorSpecialization
          : null,
    );
    Map<String, dynamic> data = reacter.toJson();
    data['react_time'] = Timestamp.now();
    await _getCommentReactsCollectionById(postDocumentId, commentDocumentId)
        .doc(currentUserId)
        .set(data);
    await _updateCommentReacts(postDocumentId, commentDocumentId, true);
    if (currentUserId != commentWriterId) {
      NotificationsController.find.notifyReact(
        writerId: commentWriterId,
        postId: postDocumentId,
        commentId: commentDocumentId,
        reactedComponent: 'تعليقك',
      );
    }
  }

  unReactComment(String postDocumentId, String commentDocumentId) async {
    _getCommentReactsCollectionById(postDocumentId, commentDocumentId)
        .doc(currentUserId)
        .delete();
    await _updateCommentReacts(postDocumentId, commentDocumentId, false);
  }

  CollectionReference _getPostCommentsCollectionById(String postId) =>
      _userDataController.getPostCommentsCollectionById(postId);

  Future<void> _showPostComments(
      QuerySnapshot<Object?> snapshot, bool isRefresh) async {
    if (isRefresh) {
      comments.clear();
    }
    if (snapshot.size == 0) {
      loading.value = false;
      moreCommentsloading.value = false;
      return;
    }
    _lastShowenComment = snapshot.docs.last;

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
          _authenticationController.currentUser.userId!,
          comment.postId,
          comment.commentId);
      comments.add(comment);
      loading.value = false;
    }
    moreCommentsloading.value = false;
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
                        await loadPostComments(3, true).then((value) =>
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

  bool isCurrentUserComment(String uid) => (uid == currentUserId);

  UserType get currentUserType => _authenticationController.currentUserType;
  String get currentUserId => _authenticationController.currentUserId;
  String get currentUserName => _authenticationController.currentUserName;
  String? get currentUserPersonalImage =>
      _authenticationController.currentUserPersonalImage;
  Gender get currentUserGender => _authenticationController.currentUserGender;
  String get currentDoctorSpecialization =>
      _authenticationController.currentDoctorSpecialization;
}
