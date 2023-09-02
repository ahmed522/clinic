import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/features/time_line/model/doctor_post_model.dart';
import 'package:clinic/global/data/models/doctor_model.dart';
import 'package:clinic/global/widgets/error_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DoctorPostsController extends GetxController {
  DoctorPostsController({required this.doctorId});

  static DoctorPostsController get find => Get.find();
  final _authController = AuthenticationController.find;
  final _userDataController = UserDataController.find;
  RxBool loadingPosts = true.obs;
  RxBool morePostsLoading = false.obs;
  RxBool noMorePosts = false.obs;
  DocumentSnapshot? _lastPostShown;
  final String doctorId;
  DoctorModel doctor = DoctorModel();
  RxList<DoctorPostModel> content = <DoctorPostModel>[].obs;
  @override
  void onReady() async {
    if (_authController.currentUserId == doctorId) {
      doctor = _authController.currentUser as DoctorModel;
    } else {
      doctor = await _userDataController.getDoctorById(doctorId);
    }
    loadDoctorPosts(20, true);
    super.onReady();
  }

  Future<void> loadDoctorPosts(int limit, bool isRefresh) async {
    if (isRefresh) {
      loadingPosts.value = true;
    }
    morePostsLoading.value = true;
    try {
      QuerySnapshot snapshot;
      if (isRefresh) {
        snapshot = await _allUsersPostsCollection
            .where('uid', isEqualTo: doctorId)
            .orderBy('time_stamp', descending: true)
            .limit(limit)
            .get();
      } else {
        snapshot = await _allUsersPostsCollection
            .where('uid', isEqualTo: doctorId)
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

      _showDoctorPosts(snapshot, isRefresh);
    } catch (e) {
      loadingPosts.value = false;
      morePostsLoading.value = false;
      Get.to(() => const ErrorPage(
            imageAsset: 'assets/img/error.svg',
            message:
                'حدثت مشكلة نعمل على حلها الان، يرجى إعادة المحاولة لاحقاً',
          ));
    }
  }

  _showDoctorPosts(QuerySnapshot snapshot, bool isRefresh) async {
    if (isRefresh) {
      content.clear();
    }
    _lastPostShown = snapshot.docs.last;
    for (var postSnapShot in snapshot.docs) {
      final String postDocumentId = postSnapShot.id;
      DoctorPostModel post = DoctorPostModel.fromSnapShot(
          postSnapShot: postSnapShot as DocumentSnapshot<Map<String, dynamic>>,
          writer: doctor);
      post.reacted = await _userDataController.isUserReactedPost(
          _authController.currentUserId, postDocumentId);

      content.add(post);
      loadingPosts.value = false;
    }
    morePostsLoading.value = false;
  }

  CollectionReference get _allUsersPostsCollection =>
      _userDataController.getAllUsersPostsCollection;
}
