import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/features/time_line/model/user_post_model.dart';
import 'package:clinic/features/time_line/pages/post/user_post/user_post_widget.dart';
import 'package:clinic/global/widgets/error_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UserQuestionsController extends GetxController {
  static UserQuestionsController get find => Get.find();
  final _authController = AuthenticationController.find;
  final _userDataController = UserDataController.find;
  RxBool loadingPosts = true.obs;
  RxBool noPosts = false.obs;
  @override
  void onReady() {
    loadUserPosts();
    super.onReady();
  }

  RxList<UserPostWidget> content = <UserPostWidget>[].obs;
  Future<void> loadUserPosts() async {
    try {
      loadingPosts.value = true;

      QuerySnapshot snapshot = await _userDataController
          .getAllUsersPostsCollection()
          .where('uid', isEqualTo: _authController.currentUserId)
          .orderBy('time_stamp', descending: true)
          .get();
      if (snapshot.size == 0) {
        noPosts.value = true;
        loadingPosts.value = false;
        return;
      }
      content.clear();
      _showUserQuestions(snapshot);
    } catch (e) {
      Get.off(() => const ErrorPage(
            imageAsset: 'assets/img/error.svg',
            message:
                'حدثت مشكلة نعمل على حلها الان، يرجى إعادة المحاولة لاحقاً',
          ));
    }
  }

  _showUserQuestions(QuerySnapshot snapshot) async {
    for (var postSnapShot in snapshot.docs) {
      final String postDocumentId = postSnapShot.id;
      UserPostModel post = UserPostModel.fromSnapShot(
          postSnapShot: postSnapShot as DocumentSnapshot<Map<String, dynamic>>,
          writer: _authController.currentUser);
      post.reacted = await _userDataController.isUserReactedPost(
          _authController.currentUser!.userId!, postDocumentId);
      loadingPosts.value = false;
      content.add(UserPostWidget(post: post));
    }
  }
}
