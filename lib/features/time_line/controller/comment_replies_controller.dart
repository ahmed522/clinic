import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/features/following/model/follower_model.dart';
import 'package:clinic/features/notifications/controller/notifications_controller.dart';
import 'package:clinic/features/settings/model/reply_activity_model.dart';
import 'package:clinic/features/time_line/model/reply_model.dart';
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

class CommentRepliesController extends GetxController {
  static CommentRepliesController get find => Get.find();
  final _authenticationController = AuthenticationController.find;
  final _userDataController = UserDataController.find;
  RxBool loading = false.obs;
  RxBool noMoreReplies = false.obs;
  RxBool moreRepliesloading = false.obs;
  RxList<ReplyModel> replies = <ReplyModel>[].obs;
  DocumentSnapshot? _lastShowenComment;
  late String commentId;
  CommentRepliesController(this.commentId);

  @override
  void onReady() {
    loadCommentReplies(2, true);
    super.onReady();
  }

  Future loadCommentReplies(int limit, bool isRefresh) async {
    if (isRefresh) {
      loading.value = true;
    }
    moreRepliesloading.value = true;

    try {
      QuerySnapshot snapshot;
      if (isRefresh) {
        snapshot = await _getCommentRepliesCollectionById(commentId)
            .orderBy('comment_time', descending: false)
            .limit(limit)
            .get();
      } else {
        snapshot = await _getCommentRepliesCollectionById(commentId)
            .orderBy('comment_time', descending: false)
            .startAfterDocument(_lastShowenComment!)
            .limit(limit)
            .get();
      }
      if (snapshot.size < limit) {
        noMoreReplies.value = true;
      } else {
        noMoreReplies.value = false;
      }

      _showCommentReplies(snapshot, isRefresh);
    } catch (e) {
      loading.value = false;
      Get.off(
        () => const ErrorPage(
          imageAsset: 'assets/img/error.svg',
          message: 'حدثت مشكلة نعمل على حلها الان، يرجى إعادة المحاولة لاحقاً',
        ),
      );
    }
  }

  reactReply(ReplyModel reply) async {
    FollowerModel reacter = FollowerModel(
      userType: currentUserType,
      userId: currentUserId,
      userName: currentUserName,
      gender: currentUserGender,
      doctorSpecialization: (currentUserType == UserType.doctor)
          ? currentDoctorSpecialization
          : null,
    );
    Map<String, dynamic> data = reacter.toJson();
    data['react_time'] = Timestamp.now();
    await _getReplyReactsCollectionById(reply.replyId)
        .doc(currentUserId)
        .set(data);
    await _updateReplyReacts(reply.commentId, reply.replyId, true);
    ReplyActivityModel replyActivity = ReplyActivityModel(
      postId: reply.postId,
      commentId: commentId,
      replyId: reply.replyId,
      replyWriterId: reply.writer.userId!,
      replyWriterName: reply.writer.userName!,
      replyWriterType: reply.writer.userType,
      replyWriterGender: reply.writer.gender,
      activityTime: data['react_time'],
    );
    await _userDataController.uploadUserLikedReplyActivity(
        currentUserId, replyActivity);
    if (currentUserId != reply.writer.userId) {
      NotificationsController.find.notifyReact(
        writerId: reply.writer.userId!,
        postId: reply.postId,
        commentId: reply.commentId,
        replyId: reply.replyId,
        reactedComponent: 'ردك',
      );
    }
  }

  unReactReply(String replyDocumentId) async {
    _getReplyReactsCollectionById(replyDocumentId).doc(currentUserId).delete();
    await _updateReplyReacts(commentId, replyDocumentId, false);
    await _userDataController
        .getUserLikedReplies(currentUserId)
        .doc(replyDocumentId)
        .delete();
  }

  CollectionReference _getCommentRepliesCollectionById(String commentId) =>
      _userDataController.getCommentRepliesCollectionById(commentId);

  Future<void> _showCommentReplies(
      QuerySnapshot<Object?> snapshot, bool isRefresh) async {
    if (isRefresh) {
      replies.clear();
    }

    if (snapshot.size == 0) {
      loading.value = false;
      moreRepliesloading.value = false;
      return;
    }
    _lastShowenComment = snapshot.docs.last;
    for (var replySnapshot in snapshot.docs) {
      final String uid = replySnapshot.get('uid');
      final UserType userType = replySnapshot.get('writer_type') == 'doctor'
          ? UserType.doctor
          : UserType.user;
      final ParentUserModel writer;
      if (userType == UserType.doctor) {
        writer = await _userDataController.getDoctorById(uid);
      } else {
        writer = await _userDataController.getUserById(uid);
      }
      ReplyModel reply = ReplyModel.fromSnapshot(
        commentSnapshot:
            replySnapshot as DocumentSnapshot<Map<String, dynamic>>,
        writer: writer,
      );
      reply.reacted = await _userDataController.isUserReactedReply(
        currentUserId,
        reply.replyId,
      );
      replies.add(reply);
      loading.value = false;
    }
    moreRepliesloading.value = false;
  }

  CollectionReference _getReplyReactsCollectionById(
    String replyDocumentId,
  ) =>
      _userDataController.getSingleReplyReactsById(replyDocumentId);

  _updateReplyReacts(
      String commentDocumentId, String replyDocumentId, bool plus) async {
    int factor = -1;
    if (plus) {
      factor = 1;
    }
    int oldReacts =
        await _getReplyReactsById(commentDocumentId, replyDocumentId);
    await _getReplyDocumentRefById(commentDocumentId, replyDocumentId)
        .update({'reacts': oldReacts + factor});
  }

  Future<int> _getReplyReactsById(
      String commentDocumentId, String replyDocumentId) async {
    int? reacts;
    await _getReplyDocumentRefById(commentDocumentId, replyDocumentId)
        .get()
        .then((value) {
      final data = value.data() as Map<String, dynamic>;
      reacts = data['reacts'];
    });
    return reacts!;
  }

  onReplySettingsButtonPressed(BuildContext context, String replyId) {
    Get.bottomSheet(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: () => MyAlertDialog.showAlertDialog(
              context,
              'حذف الرد',
              'هل انت متأكد من حذف هذا الرد؟',
              MyAlertDialog.getAlertDialogActions(
                {
                  'نعم': () async {
                    try {
                      loading.value = true;
                      Get.back(closeOverlays: true);
                      await _deleteReplyById(commentId, replyId)
                          .whenComplete(() async {
                        Get.back();
                        await loadCommentReplies(3, true).then((value) =>
                            MySnackBar.showGetSnackbar(
                                'تم حذف الرد بنجاح', Colors.green));
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
                'حذف الرد',
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

  Future<void> _deleteReplyById(String commentId, String replyId) async {
    _userDataController.deleteReplyById(currentUserId, commentId, replyId);
  }

  DocumentReference _getReplyDocumentRefById(
    String commentDocumentId,
    String replyDocumentId,
  ) =>
      _userDataController.getReplyDocumentById(
          commentDocumentId, replyDocumentId);

  bool isCurrentUserReply(String uid) => (uid == currentUserId);

  UserType get currentUserType => _authenticationController.currentUserType;
  String get currentUserId => _authenticationController.currentUserId;
  String get currentUserName => _authenticationController.currentUserName;
  String? get currentUserPersonalImage =>
      _authenticationController.currentUserPersonalImage;
  Gender get currentUserGender => _authenticationController.currentUserGender;
  String get currentDoctorSpecialization =>
      _authenticationController.currentDoctorSpecialization;
}
