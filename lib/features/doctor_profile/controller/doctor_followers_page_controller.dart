import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/features/following/model/follower_model.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/error_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DoctorFollowersPageController extends GetxController {
  DoctorFollowersPageController(this.doctorId);

  static DoctorFollowersPageController get find => Get.find();
  final UserDataController _userDataController = UserDataController.find;
  final AuthenticationController _authenticationController =
      AuthenticationController.find;

  RxBool loading = true.obs;
  RxBool moreFollowersLoading = false.obs;
  RxBool noMoreFollowers = false.obs;
  DocumentSnapshot? _lastFollowerShown;
  RxList<FollowerModel> followers = <FollowerModel>[].obs;
  final String doctorId;

  @override
  void onReady() async {
    await loadDoctorFollowers(20, true);
    super.onReady();
  }

  Future<void> loadDoctorFollowers(int limit, bool isRefresh) async {
    if (isRefresh) {
      loading.value = true;
    }
    moreFollowersLoading.value = true;
    try {
      QuerySnapshot snapshot;
      if (isRefresh) {
        snapshot = await _userDataController
            .getDoctorFollowersCollectionById(doctorId)
            .orderBy('follow_time')
            .limit(limit)
            .get();
      } else {
        snapshot = await _userDataController
            .getDoctorFollowersCollectionById(doctorId)
            .orderBy('follow_time')
            .startAfterDocument(_lastFollowerShown!)
            .limit(limit)
            .get();
      }

      if (snapshot.size < limit) {
        noMoreFollowers.value = true;
      } else {
        noMoreFollowers.value = false;
      }
      if (snapshot.size == 0) {
        loading.value = false;
        moreFollowersLoading.value = false;
        return;
      }

      _getDoctorFollowers(snapshot, isRefresh);
    } catch (e) {
      loading.value = false;
      moreFollowersLoading.value = false;
      Get.off(
        () => const ErrorPage(
          imageAsset: 'assets/img/error.svg',
          message: 'حدثت مشكلة نعمل على حلها الان، يرجى إعادة المحاولة لاحقاً',
        ),
      );
    }
  }

  _getDoctorFollowers(QuerySnapshot snapshot, bool isRefresh) async {
    if (isRefresh) {
      followers.clear();
    }
    _lastFollowerShown = snapshot.docs.last;
    for (var follower in snapshot.docs) {
      FollowerModel followerModel = FollowerModel.fromSnapshot(
        follower as QueryDocumentSnapshot<Map<String, dynamic>>,
      );
      if (CommonFunctions.isCurrentUser(followerModel.userId)) {
        followerModel.userPersonalImage =
            _authenticationController.currentUserPersonalImage;
      } else {
        followerModel.userPersonalImage =
            await _userDataController.getUserPersonalImageURLById(
                followerModel.userId, followerModel.userType);
      }
      followers.add(followerModel);
      loading.value = false;
    }
    moreFollowersLoading.value = false;
  }
}
