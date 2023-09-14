import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/features/authentication/controller/local_storage_controller.dart';
import 'package:clinic/features/notifications/controller/notifications_controller.dart';
import 'package:clinic/features/time_line/model/doctor_post_model.dart';
import 'package:clinic/features/time_line/model/doctor_post_type.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/data/models/doctor_model.dart';
import 'package:clinic/global/widgets/preview_post_page.dart';
import 'package:clinic/global/widgets/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class ChangeDegreePageController extends GetxController {
  static ChangeDegreePageController get find => Get.find();

  final AuthenticationController _authenticationController =
      AuthenticationController.find;
  final UserDataController _userDataController = UserDataController.find;

  late final TextEditingController editPostTextController;
  bool loading = false;
  bool uploadPost = true;
  String degree = AuthenticationController.find.currentDoctorDegree;
  late String postContent;
  @override
  onReady() {
    postContent =
        AppConstants.newDegreePostContent(currentUserName, currentUserGender);
    editPostTextController = TextEditingController(
      text: postContent,
    );
    super.onReady();
  }

  updateDegree(String newDegree) {
    degree = newDegree;
    update();
  }

  updateUploadPost(bool value) {
    uploadPost = value;
    update();
  }

  changeDegree() async {
    updateLoading(true);
    await _userDataController.changeDoctorDegree(currentUserId, degree);
    await LocalStorageController.find.updateDoctorDegree(degree);
    if (uploadPost) {
      DoctorPostModel post = DoctorPostModel()
        ..doctorId = currentUserId
        ..postType = DoctorPostType.newDegree
        ..content = postContent
        ..timeStamp = Timestamp.now()
        ..writerType = UserType.doctor
        ..writer = currentUser.copy()
        ..degree = degree;

      String postDocumentId = '${post.doctorId}-${const Uuid().v4()}';
      post.postId = postDocumentId;
      await _getPostDocumentRefById(postDocumentId).set(post.toJson());
      NotificationsController.find.notifyFollowingDoctorPost(post);
    }
    currentUser.degree = degree;
    updateLoading(false);
    Get.back();
    MySnackBar.showGetSnackbar('تم تغيير الدرجة العلمية بنجاح', Colors.green);
  }

  onPreviewPostPressed() async {
    if (degree == currentDoctorDegree) {
      if (!Get.isSnackbarOpen) {
        MySnackBar.showGetSnackbar(
          'لم تقم بتغيير درجتك العلمية',
          AppColors.primaryColor,
          isTop: false,
          duration: const Duration(milliseconds: 1000),
        );
      }
    } else {
      DoctorPostModel post = DoctorPostModel()
        ..doctorId = currentUserId
        ..postType = DoctorPostType.newDegree
        ..content = postContent
        ..timeStamp = Timestamp.now()
        ..writerType = UserType.doctor
        ..writer = currentUser.copy()
        ..degree = degree;

      Get.to(
        () => PreviewPostPage(
          post: post,
        ),
        transition: Transition.rightToLeftWithFade,
      );
    }
  }

  updateLoading(bool value) {
    loading = value;
    update();
  }

  DocumentReference _getPostDocumentRefById(String postDocumentId) =>
      _userDataController.getAllUsersPostsCollection.doc(postDocumentId);
  DoctorModel get currentUser =>
      _authenticationController.currentUser as DoctorModel;
  UserType get currentUserType => _authenticationController.currentUserType;
  String get currentUserId => _authenticationController.currentUserId;
  String get currentUserName => _authenticationController.currentUserName;
  Gender get currentUserGender => _authenticationController.currentUserGender;

  String get currentDoctorDegree =>
      _authenticationController.currentDoctorDegree;
}
