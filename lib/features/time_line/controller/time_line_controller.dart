import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/features/time_line/model/user_post_model.dart';
import 'package:clinic/features/time_line/pages/post/user_post/user_post_widget.dart';
import 'package:clinic/global/widgets/error_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TimeLineController extends GetxController {
  static TimeLineController get find => Get.find();
  final _authController = AuthenticationController.find;
  RxBool loadingPosts = true.obs;
  RxBool noPosts = false.obs;
  @override
  void onReady() {
    loadPosts();
    super.onReady();
  }

  final _userDataController = UserDataController.find;
  RxList<UserPostWidget> content = <UserPostWidget>[].obs;
  Future<void> loadPosts() async {
    try {
      loadingPosts.value = true;
      QuerySnapshot snapshot = await _userDataController
          .getAllUsersPostsCollection()
          .orderBy('time_stamp', descending: true)
          .get();
      if (snapshot.size == 0) {
        noPosts.value = true;
        loadingPosts.value = false;
        return;
      }
      noPosts.value = false;
      content.clear();
      _showPostsOnTimeLine(snapshot);
    } catch (e) {
      loadingPosts.value = false;
      noPosts.value = false;

      Get.off(() => const ErrorPage(
            imageAsset: 'assets/img/error.svg',
            message:
                'حدثت مشكلة نعمل على حلها الان، يرجى إعادة المحاولة لاحقاً',
          ));
    }
  }

  _showPostsOnTimeLine(QuerySnapshot snapshot) async {
    for (var postSnapShot in snapshot.docs) {
      final String uid = postSnapShot.get('uid');
      final String postDocumentId = postSnapShot.id;
      final userModel = await _userDataController.getUserById(uid);
      UserPostModel post = UserPostModel.fromSnapShot(
          postSnapShot: postSnapShot as DocumentSnapshot<Map<String, dynamic>>,
          writer: userModel);
      post.reacted = await _userDataController.isUserReactedPost(
          _authController.currentUser!.userId!, postDocumentId);
      loadingPosts.value = false;
      content.add(UserPostWidget(post: post));
    }
  }
}
