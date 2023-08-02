import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/features/following/model/follower_model.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:clinic/global/widgets/error_page.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoctorFollowingsPageController extends GetxController {
  DoctorFollowingsPageController(this.doctorId);

  static DoctorFollowingsPageController get find => Get.find();
  final UserDataController _userDataController = UserDataController.find;
  final AuthenticationController _authenticationController =
      AuthenticationController.find;
  RxBool loading = true.obs;
  RxBool moreFollowingsLoading = false.obs;
  RxBool noMoreFollowings = false.obs;
  DocumentSnapshot? _lastFollowingShown;
  RxList<FollowerModel> followings = <FollowerModel>[].obs;
  final String doctorId;
  @override
  void onReady() async {
    await loadDoctorFollowings(20, true);
    super.onReady();
  }

  Future<void> loadDoctorFollowings(int limit, bool isRefresh) async {
    if (isRefresh) {
      loading.value = true;
    }
    moreFollowingsLoading.value = true;
    try {
      QuerySnapshot snapshot;
      if (isRefresh) {
        snapshot = await _userDataController
            .getUserFollowingCollectionById(doctorId)
            .orderBy('follow_time')
            .limit(limit)
            .get();
      } else {
        snapshot = await _userDataController
            .getUserFollowingCollectionById(doctorId)
            .orderBy('follow_time')
            .startAfterDocument(_lastFollowingShown!)
            .limit(limit)
            .get();
      }

      if (snapshot.size < limit) {
        noMoreFollowings.value = true;
      } else {
        noMoreFollowings.value = false;
      }
      if (snapshot.size == 0) {
        loading.value = false;
        moreFollowingsLoading.value = false;
        return;
      }
      _getDoctorFollowings(snapshot, isRefresh);
    } catch (e) {
      loading.value = false;
      moreFollowingsLoading.value = false;
      Get.off(
        () => const ErrorPage(
          imageAsset: 'assets/img/error.svg',
          message: 'حدثت مشكلة نعمل على حلها الان، يرجى إعادة المحاولة لاحقاً',
        ),
      );
    }
  }

  _getDoctorFollowings(QuerySnapshot snapshot, bool isRefresh) async {
    if (isRefresh) {
      followings.clear();
    }
    _lastFollowingShown = snapshot.docs.last;
    for (var following in snapshot.docs) {
      FollowerModel followingModel = FollowerModel.fromSnapshot(
        following as QueryDocumentSnapshot<Map<String, dynamic>>,
      );
      if (CommonFunctions.isCurrentUser(followingModel.userId)) {
        followingModel.userPersonalImage =
            _authenticationController.currentUserPersonalImage;
      } else {
        followingModel.userPersonalImage =
            await _userDataController.getUserPersonalImageURLById(
                followingModel.userId, followingModel.userType);
      }
      followings.add(followingModel);

      loading.value = false;
    }
    moreFollowingsLoading.value = false;
  }

  onUnfollowButtonPressed(BuildContext context, FollowerModel follower) {
    MyAlertDialog.showAlertDialog(
      context,
      'إلغاء المتابعة',
      'هل أنت متأكد من إلغاء متابعة الطبيب ${follower.userName}',
      MyAlertDialog.getAlertDialogActions(
        {
          'العودة': () => Get.back(),
          'تأكيد': () async {
            Get.back();
            loading.value = true;
            try {
              await _userDataController.unFollowDoctor(
                  follower.userId, currentUserId);
              loadDoctorFollowings(20, true);
            } on Exception {
              CommonFunctions.errorHappened();
            }
          }
        },
      ),
    );
  }

  String get currentUserId => _authenticationController.currentUserId;
}
