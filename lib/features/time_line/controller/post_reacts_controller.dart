import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/features/following/model/follower_model.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class PostReactsController extends GetxController {
  static PostReactsController get find => Get.find();
  PostReactsController({required this.postId});
  final UserDataController _userDataController = UserDataController.find;
  final String postId;
  RxList<FollowerModel> reacts = <FollowerModel>[].obs;
  DocumentSnapshot? _lastShowenReact;
  RxBool noMoreReacts = false.obs;
  RxBool loading = true.obs;
  RxBool moreReactsloading = false.obs;

  @override
  void onReady() {
    loadPostReacts(1, true);
    super.onReady();
  }

  Future loadPostReacts(int limit, bool isRefresh) async {
    loading.value = true;
    try {
      QuerySnapshot snapshot;
      if (isRefresh) {
        snapshot = await _getPostReactsCollectionById(postId)
            .orderBy('react_time', descending: false)
            .limit(limit)
            .get();
      } else {
        snapshot = await _getPostReactsCollectionById(postId)
            .orderBy('react_time', descending: false)
            .startAfterDocument(_lastShowenReact!)
            .limit(limit)
            .get();
      }
      if (snapshot.size < limit) {
        noMoreReacts.value = true;
      } else {
        noMoreReacts.value = false;
      }
      _showPostReacts(
        snapshot,
        isRefresh,
      );
    } catch (e) {
      loading.value = false;
      CommonFunctions.errorHappened();
    }
  }

  Future<void> _showPostReacts(
      QuerySnapshot<Object?> snapshot, bool isRefresh) async {
    if (isRefresh) {
      reacts.clear();
    }
    if (snapshot.size == 0) {
      loading.value = false;
      return;
    }
    _lastShowenReact = snapshot.docs.last;
    for (var reactSnapshot in snapshot.docs) {
      FollowerModel react = FollowerModel.fromSnapshot(
        reactSnapshot as QueryDocumentSnapshot<Map<String, dynamic>>,
      );
      react.userPersonalImage = await _userDataController
          .getUserPersonalImageURLById(react.userId, react.userType);
      reacts.add(react);
      loading.value = false;
    }
  }

  CollectionReference _getPostReactsCollectionById(String postDocumentId) =>
      _userDataController.getPostReactsCollectionById(postDocumentId);
}
