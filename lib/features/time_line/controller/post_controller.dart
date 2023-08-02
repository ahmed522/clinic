import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/features/following/model/follower_model.dart';
import 'package:clinic/features/time_line/controller/time_line_controller.dart';
import 'package:clinic/features/time_line/model/doctor_post_model.dart';
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
    String postDocumentId = '${post.user.userId}-${const Uuid().v4()}';
    post.postId = postDocumentId;

    await _getPostDocumentRefById(postDocumentId)
        .set(post.toJson())
        .catchError(
          (error) => Get.to(
            () => const ErrorPage(
              imageAsset: 'assets/img/error.svg',
              message: '  حدثت مشكلة، يرجى إعادة المحاولة لاحقاً',
            ),
          ),
        )
        .whenComplete(() async {
      await _loadPosts();
      MySnackBar.showGetSnackbar('تم نشر سؤالك بنجاح', Colors.green);
    }).catchError(
      (error) => Get.to(
        () => const ErrorPage(
          imageAsset: 'assets/img/error.svg',
          message: '  حدثت مشكلة، يرجى إعادة المحاولة لاحقاً',
        ),
      ),
    );
  }

  uploadDoctorPost(DoctorPostModel post) async {
    String postDocumentId = '${post.doctorId}-${const Uuid().v4()}';
    post.postId = postDocumentId;
    await _getPostDocumentRefById(postDocumentId)
        .set(post.toJson())
        .whenComplete(() async {
      await _loadPosts();
      MySnackBar.showGetSnackbar('تم نشر منشورك بنجاح', Colors.green);
    }).catchError(
      (error) => CommonFunctions.errorHappened(),
    );
  }

  reactPost(String uid, String postDocumentId) async {
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
    _getPostReactsCollectionById(postDocumentId).doc(currentUserId).set(data);
    await _updatePostReacts(uid, postDocumentId, true);
  }

  unReactPost(String uid, String postDocumentId) async {
    await _getPostReactsCollectionById(postDocumentId)
        .doc(currentUserId)
        .delete();
    await _updatePostReacts(uid, postDocumentId, false);
  }

  _updatePostReacts(String uid, String postDocumentId, bool plus) async {
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
      final data = value.data() as Map<String, dynamic>;
      reacts = data['reacts'];
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
                      await _deletePostById(postId, isDoctorPost)
                          .whenComplete(() async {
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

  Future _deletePostById(String postDocumentId, bool isDoctorPost) =>
      _userDataController.deletePostById(postDocumentId, isDoctorPost);
  DocumentReference _getPostDocumentRefById(String postDocumentId) =>
      _userDataController.getAllUsersPostsCollection().doc(postDocumentId);
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
