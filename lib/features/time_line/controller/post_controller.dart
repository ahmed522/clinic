import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/features/following/model/follower_model.dart';
import 'package:clinic/features/notifications/controller/notifications_controller.dart';
import 'package:clinic/features/settings/model/post_activity_model.dart';
import 'package:clinic/features/time_line/controller/time_line_controller.dart';
import 'package:clinic/features/time_line/model/doctor_post_model.dart';
import 'package:clinic/features/time_line/model/parent_post_model.dart';
import 'package:clinic/features/time_line/model/user_post_model.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:clinic/global/widgets/error_page.dart';
import 'package:clinic/global/widgets/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class PostController extends GetxController {
  static PostController get find => Get.find();
  final _authenticationController = AuthenticationController.find;
  final _userDataController = UserDataController.find;
  final _timeLineController = TimeLineController.find;

  uploadUserPost(UserPostModel post) async {
    try {
      String postDocumentId = '${post.user.userId}-${const Uuid().v4()}';
      post.postId = postDocumentId;
      Map<String, dynamic> data = post.toJson();
      data['allowed'] = false;
      await _getPostDocumentRefById(postDocumentId).set(data);
      MySnackBar.showGetSnackbar('سيتم نشر سؤالك حال مراجعته', Colors.green);
    } catch (e) {
      Get.to(
        () => const ErrorPage(
          imageAsset: 'assets/img/error.svg',
          message: '  حدثت مشكلة، يرجى إعادة المحاولة لاحقاً',
        ),
      );
    }
  }

  uploadDoctorPost(DoctorPostModel post) async {
    try {
      String postDocumentId = '${post.doctorId}-${const Uuid().v4()}';
      post.postId = postDocumentId;
      post.postId = postDocumentId;
      Map<String, dynamic> data = post.toJson();
      data['allowed'] = true;
      await _getPostDocumentRefById(postDocumentId).set(data);
      NotificationsController.find.notifyFollowingDoctorPost(post);
      MySnackBar.showGetSnackbar('تم نشر منشورك بنجاح', Colors.green);
    } catch (e) {
      Get.to(
        () => const ErrorPage(
          imageAsset: 'assets/img/error.svg',
          message: '  حدثت مشكلة، يرجى إعادة المحاولة لاحقاً',
        ),
      );
    }
  }

  reactPost(ParentPostModel post) async {
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
    _getPostReactsCollectionById(post.postId!).doc(currentUserId).set(data);
    await _updatePostReacts(post.postId!, true);
    String postWriterId = (post.writerType == UserType.doctor)
        ? (post as DoctorPostModel).writer!.userId!
        : (post as UserPostModel).user.userId!;
    String postWriterName = (post.writerType == UserType.doctor)
        ? (post as DoctorPostModel).writer!.userName!
        : (post as UserPostModel).user.userName!;
    Gender postWriterGender = (post.writerType == UserType.doctor)
        ? (post as DoctorPostModel).writer!.gender
        : (post as UserPostModel).user.gender;
    PostActivityModel postActivity = PostActivityModel(
      postId: post.postId!,
      postWriterId: postWriterId,
      postWriterName: postWriterName,
      postWriterType: post.writerType!,
      postWriterGender: postWriterGender,
      activityTime: data['react_time'],
    );

    await _userDataController.uploadUserLikedPostActivity(
        currentUserId, postActivity);
    if (currentUserId != postWriterId) {
      NotificationsController.find.notifyReact(
        writerId: postWriterId,
        postId: post.postId!,
        reactedComponent: 'منشورك',
      );
    }
  }

  unReactPost(String postId) async {
    await _getPostReactsCollectionById(postId).doc(currentUserId).delete();
    await _updatePostReacts(postId, false);
    await _userDataController
        .getUserLikedPosts(currentUserId)
        .doc(postId)
        .delete();
  }

  _updatePostReacts(String postDocumentId, bool plus) async {
    int factor = -1;
    if (plus) {
      factor = 1;
    }
    int oldReacts = await _getPostReactsById(postDocumentId);
    await _getPostDocumentRefById(postDocumentId)
        .update({'reacts': oldReacts + factor});
  }

  Future<int> _getPostReactsById(String postDocumentId) async {
    int? reacts;
    await _getPostDocumentRefById(postDocumentId).get().then((value) {
      reacts = value['reacts'];
    });
    return reacts!;
  }

  onPostSettingsButtonPressed(BuildContext context, String postId,
      [bool isDoctorPost = false]) {
    Get.bottomSheet(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: () => MyAlertDialog.showAlertDialog(
              context,
              isDoctorPost ? 'حذف المنشور' : 'حذف السؤال',
              isDoctorPost
                  ? 'هل انت متأكد من حذف هذا المنشور؟'
                  : 'هل انت متأكد من حذف هذا السؤال؟',
              MyAlertDialog.getAlertDialogActions(
                {
                  'نعم': () async {
                    try {
                      _timeLineController.loadingPosts.value = true;
                      Get.back(closeOverlays: true);
                      await _deletePostById(postId).whenComplete(() async {
                        await _loadPosts();
                        MySnackBar.showGetSnackbar(
                            isDoctorPost
                                ? 'تم حذف المنشور بنجاح'
                                : 'تم حذف السؤال بنجاح',
                            Colors.green);
                      });
                    } catch (e) {
                      CommonFunctions.errorHappened();
                    }
                  },
                  'إلغاء': () => Get.back(closeOverlays: true),
                },
              ),
            ),
            title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'حذف',
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

  Future _deletePostById(String postDocumentId) =>
      _userDataController.deletePostById(postDocumentId);
  DocumentReference _getPostDocumentRefById(String postDocumentId) =>
      _userDataController.getAllUsersPostsCollection.doc(postDocumentId);
  CollectionReference _getPostReactsCollectionById(String postDocumentId) =>
      _userDataController.getPostReactsCollectionById(postDocumentId);

  _loadPosts() => _timeLineController.loadPosts(50, true);
  bool isCurrentUserPost(String uid) => (uid == currentUserId);

  Future<String> getPostWriterName(String uid, String userType) async {
    switch (userType) {
      case 'doctor':
        return await _userDataController.getUserNameById(uid, UserType.doctor);
      default:
        return await _userDataController.getUserNameById(uid, UserType.user);
    }
  }

  Future<String?> getPostWriterPersonalImage(
      String uid, String userType) async {
    switch (userType) {
      case 'doctor':
        return await _userDataController.getUserPersonalImageURLById(
            uid, UserType.doctor);
      default:
        return await _userDataController.getUserPersonalImageURLById(
            uid, UserType.user);
    }
  }

  UserType get currentUserType => _authenticationController.currentUserType;
  String get currentUserId => _authenticationController.currentUserId;
  String get currentUserName => _authenticationController.currentUserName;
  String? get currentUserPersonalImage =>
      _authenticationController.currentUserPersonalImage;
  Gender get currentUserGender => _authenticationController.currentUserGender;
  String get currentDoctorSpecialization =>
      _authenticationController.currentDoctorSpecialization;
}
