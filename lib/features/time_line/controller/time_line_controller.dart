import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/features/time_line/model/doctor_post_model.dart';
import 'package:clinic/features/time_line/model/parent_post_model.dart';
import 'package:clinic/features/time_line/model/user_post_model.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/data/models/doctor_model.dart';
import 'package:clinic/global/data/models/user_model.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/error_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TimeLineController extends GetxController {
  static TimeLineController get find => Get.find();
  RxBool loadingPosts = true.obs;
  RxBool morePostsLoading = false.obs;
  RxBool noMorePosts = false.obs;
  DocumentSnapshot? _lastPostShown;
  RxList<ParentPostModel> content = <ParentPostModel>[].obs;
  @override
  void onReady() {
    loadPosts(50, true);
    super.onReady();
  }

  final _authenticationController = AuthenticationController.find;
  final _userDataController = UserDataController.find;
  Future<void> loadPosts(int limit, bool isRefresh) async {
    if (isRefresh) {
      loadingPosts.value = true;
    }
    morePostsLoading.value = true;
    try {
      QuerySnapshot snapshot;
      if (isRefresh) {
        snapshot = await _userDataController.getAllUsersPostsCollection
            .where('allowed', isEqualTo: true)
            .orderBy('time_stamp', descending: true)
            .limit(limit)
            .get();
      } else {
        snapshot = await _userDataController.getAllUsersPostsCollection
            .where('allowed', isEqualTo: true)
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
        if (isRefresh) {
          content.clear();
        }
        loadingPosts.value = false;
        morePostsLoading.value = false;
        return;
      }
      _showPostsOnTimeLine(snapshot, isRefresh);
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

  _showPostsOnTimeLine(QuerySnapshot snapshot, bool isRefresh) async {
    if (isRefresh) {
      content.clear();
    } else {
      content.removeRange(0, content.length ~/ 2);
    }
    _lastPostShown = snapshot.docs.last;

    for (var postSnapShot in snapshot.docs) {
      final String uid = postSnapShot.get('uid');
      final String postDocumentId = postSnapShot.id;
      final UserType writerType = postSnapShot.get('user_type') == 'doctor'
          ? UserType.doctor
          : UserType.user;
      if (writerType == UserType.user) {
        UserModel userModel;
        if (CommonFunctions.isCurrentUser(uid)) {
          userModel = _authenticationController.currentUser as UserModel;
        } else {
          userModel = await _userDataController.getUserById(uid);
        }
        UserPostModel post = UserPostModel.fromSnapShot(
            postSnapShot:
                postSnapShot as DocumentSnapshot<Map<String, dynamic>>,
            writer: userModel);
        post.reacted = await _userDataController.isUserReactedPost(
            _authenticationController.currentUserId, postDocumentId);
        content.add(post);
      } else {
        DoctorModel doctorModel;
        if (CommonFunctions.isCurrentUser(uid)) {
          doctorModel = _authenticationController.currentUser as DoctorModel;
        } else {
          doctorModel = await _userDataController.getDoctorById(uid);
        }
        DoctorPostModel post = DoctorPostModel.fromSnapShot(
          postSnapShot: postSnapShot as DocumentSnapshot<Map<String, dynamic>>,
          writer: doctorModel,
        );

        post.reacted = await _userDataController.isUserReactedPost(
            _authenticationController.currentUserId, postDocumentId);

        content.add(post);
      }
      loadingPosts.value = false;
    }
    morePostsLoading.value = false;
  }
}
