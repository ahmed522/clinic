import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/features/time_line/model/user_post_model.dart';
import 'package:clinic/global/data/models/user_model.dart';
import 'package:clinic/global/widgets/error_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UserQuestionsController extends GetxController {
  static UserQuestionsController get find => Get.find();
  final _authController = AuthenticationController.find;
  final _userDataController = UserDataController.find;
  RxBool loadingPosts = true.obs;
  RxBool morePostsLoading = false.obs;
  RxBool noMorePosts = false.obs;
  DocumentSnapshot? _lastPostShown;
  RxList<UserPostModel> content = <UserPostModel>[].obs;
  @override
  void onReady() {
    loadUserPosts(10, true);
    super.onReady();
  }

  Future<void> loadUserPosts(int limit, bool isRefresh) async {
    if (isRefresh) {
      loadingPosts.value = true;
    }
    morePostsLoading.value = true;
    try {
      QuerySnapshot snapshot;
      if (isRefresh) {
        snapshot = await _userDataController
            .getAllUsersPostsCollection()
            .where('uid', isEqualTo: _authController.currentUserId)
            .orderBy('time_stamp', descending: true)
            .limit(limit)
            .get();
      } else {
        snapshot = await _userDataController
            .getAllUsersPostsCollection()
            .where('uid', isEqualTo: _authController.currentUserId)
            .orderBy('time_stamp', descending: true)
            .startAfterDocument(_lastPostShown!)
            .limit(limit)
            .get();
      }
      if (snapshot.size < limit) {
        noMorePosts.value = true;
      } else {
        noMorePosts.value = false;
      }
      if (snapshot.size == 0) {
        loadingPosts.value = false;
        morePostsLoading.value = false;
        return;
      }

      _showUserQuestions(snapshot, isRefresh);
    } catch (e) {
      loadingPosts.value = false;
      morePostsLoading.value = false;
      Get.off(
        () => const ErrorPage(
          imageAsset: 'assets/img/error.svg',
          message: 'حدثت مشكلة نعمل على حلها الان، يرجى إعادة المحاولة لاحقاً',
        ),
      );
    }
  }

  _showUserQuestions(QuerySnapshot snapshot, bool isRefresh) async {
    if (isRefresh) {
      content.clear();
    }
    _lastPostShown = snapshot.docs.last;
    for (var postSnapShot in snapshot.docs) {
      final String postDocumentId = postSnapShot.id;
      UserPostModel post = UserPostModel.fromSnapShot(
        postSnapShot: postSnapShot as DocumentSnapshot<Map<String, dynamic>>,
        writer: _authController.currentUser as UserModel,
      );
      post.reacted = await _userDataController.isUserReactedPost(
          _authController.currentUserId, postDocumentId);
      content.add(post);
      loadingPosts.value = false;
    }
    morePostsLoading.value = false;
  }
}
