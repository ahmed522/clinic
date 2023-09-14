import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/features/settings/controller/settings_on_pressed_functions.dart';
import 'package:clinic/features/settings/model/activity.dart';
import 'package:clinic/features/settings/model/comment_activity_model.dart';
import 'package:clinic/features/settings/model/post_activity_model.dart';
import 'package:clinic/features/settings/model/reply_activity_model.dart';
import 'package:clinic/global/widgets/error_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ActivityPageController extends GetxController {
  ActivityPageController(this.activity);
  static ActivityPageController find(String tag) => Get.find(tag: tag);
  final AuthenticationController _authenticationController =
      AuthenticationController.find;
  final UserDataController _userDataController = UserDataController.find;

  final Activity activity;
  RxBool deleteFabOpen = false.obs;
  RxBool loading = true.obs;
  RxBool moreActivitiesLoading = true.obs;
  RxBool noMoreActivities = false.obs;
  DocumentSnapshot? _lastActivityShown;
  RxList<PostActivityModel> postsActivities = <PostActivityModel>[].obs;
  RxList<CommentActivityModel> commentsActivities =
      <CommentActivityModel>[].obs;
  RxList<ReplyActivityModel> repliesActivities = <ReplyActivityModel>[].obs;
  RxList<String> deletedActivities = <String>[].obs;
  @override
  onReady() {
    loadActivities(15, true);
    super.onReady();
  }

  selectActivity(String id, bool value) {
    if (value) {
      deletedActivities.add(id);
    } else {
      deletedActivities.remove(id);
    }
  }

  deleteActivities() async {
    loading.value = true;
    switch (activity) {
      case Activity.likedPosts:
        for (String id in deletedActivities) {
          await _userDataController.deleteLikedPostById(currentUserId, id);
          postsActivities.removeWhere((element) => element.postId == id);
        }
        break;
      case Activity.likedComments:
        for (String id in deletedActivities) {
          await _userDataController.deleteLikedCommentById(currentUserId, id);
          commentsActivities.removeWhere((element) => element.commentId == id);
        }
        break;
      case Activity.writtenComments:
        for (String id in deletedActivities) {
          await _userDataController.deleteCommentActivityById(
              currentUserId, id);
          postsActivities.removeWhere((element) => element.id == id);
        }
        break;
      case Activity.writtenReplies:
        for (String id in deletedActivities) {
          await _userDataController.deleteReplyActivityById(currentUserId, id);
          commentsActivities.removeWhere((element) => element.id == id);
        }
        break;
      case Activity.likedReplies:
        for (String id in deletedActivities) {
          await _userDataController.deleteLikedReplyById(currentUserId, id);
          repliesActivities.removeWhere((element) => element.replyId == id);
        }
        break;
    }
    deletedActivities.clear();
    loading.value = false;
    deleteFabOpen.value = false;
  }

  deleteAllActivities() async {
    loading.value = true;
    switch (activity) {
      case Activity.likedPosts:
        await _userDataController.deleteAllLikedPostsById(currentUserId);
        postsActivities.clear();
        break;
      case Activity.likedComments:
        await _userDataController.deleteAllLikedCommentsById(currentUserId);
        commentsActivities.clear();
        break;
      case Activity.writtenComments:
        await _userDataController
            .deleteAllCommentsActivitiesById(currentUserId);
        postsActivities.clear();
        break;
      case Activity.writtenReplies:
        await _userDataController.deleteAllRepliesActivitiesById(currentUserId);
        commentsActivities.clear();
        break;
      case Activity.likedReplies:
        await _userDataController.deleteAllLikedRepliesById(currentUserId);
        repliesActivities.clear();
        break;
    }
    deletedActivities.clear();
    loading.value = false;
    deleteFabOpen.value = false;
  }

  Future<void> loadActivities(int limit, bool isRefresh) async {
    if (isRefresh) {
      loading.value = true;
    }
    moreActivitiesLoading.value = true;
    try {
      QuerySnapshot snapshot;
      if (isRefresh) {
        snapshot = await _getCollectionReference
            .orderBy('activity_time', descending: true)
            .limit(limit)
            .get()
            .then((snapshot) => snapshot);
      } else {
        snapshot = await _getCollectionReference
            .orderBy('activity_time', descending: true)
            .startAfterDocument(_lastActivityShown!)
            .limit(limit)
            .get()
            .then((snapshot) => snapshot);
      }
      if (snapshot.size < limit) {
        noMoreActivities.value = true;
      } else {
        noMoreActivities.value = false;
      }
      if (snapshot.size == 0) {
        if (isRefresh) {
          switch (activity) {
            case Activity.likedPosts:
            case Activity.writtenComments:
              postsActivities.clear();
              break;
            case Activity.likedComments:
            case Activity.writtenReplies:
              commentsActivities.clear();
              break;
            case Activity.likedReplies:
              repliesActivities.clear();
              break;
          }
        }
        loading.value = false;
        moreActivitiesLoading.value = false;
        return;
      }
      _showActivities(snapshot, isRefresh);
    } catch (e) {
      loading.value = false;
      moreActivitiesLoading.value = false;
      Get.off(
        () => const ErrorPage(
          imageAsset: 'assets/img/error.svg',
          message: 'حدثت مشكلة نعمل على حلها الان، يرجى إعادة المحاولة لاحقاً',
        ),
      );
    }
  }

  _showActivities(QuerySnapshot snapshot, bool isRefresh) async {
    if (isRefresh) {
      switch (activity) {
        case Activity.likedPosts:
        case Activity.writtenComments:
          postsActivities.clear();
          break;
        case Activity.likedComments:
        case Activity.writtenReplies:
          commentsActivities.clear();
          break;
        case Activity.likedReplies:
          repliesActivities.clear();
          break;
      }
    }
    _lastActivityShown = snapshot.docs.last;
    for (var documentSnapshot in snapshot.docs) {
      switch (activity) {
        case Activity.likedPosts:
          PostActivityModel postActivityModel =
              PostActivityModel.fromSnapshot(documentSnapshot);
          postsActivities.add(postActivityModel);
          break;
        case Activity.writtenComments:
          PostActivityModel postActivityModel =
              PostActivityModel.fromSnapshot(documentSnapshot);
          postActivityModel.id = documentSnapshot.id;
          postsActivities.add(postActivityModel);
          break;
        case Activity.likedComments:
          CommentActivityModel commentActivityModel =
              CommentActivityModel.fromSnapshot(documentSnapshot);
          commentsActivities.add(commentActivityModel);
          break;
        case Activity.writtenReplies:
          CommentActivityModel commentActivityModel =
              CommentActivityModel.fromSnapshot(documentSnapshot);
          commentActivityModel.id = documentSnapshot.id;
          commentsActivities.add(commentActivityModel);
          break;
        case Activity.likedReplies:
          ReplyActivityModel replyActivityModel =
              ReplyActivityModel.fromSnapshot(documentSnapshot);
          repliesActivities.add(replyActivityModel);
          break;
      }
      loading.value = false;
    }
    moreActivitiesLoading.value = false;
  }

  CollectionReference get _getCollectionReference {
    switch (activity) {
      case Activity.likedPosts:
        return _userDataController.getUserLikedPosts(currentUserId);
      case Activity.writtenComments:
        return _userDataController.getUserComments(currentUserId);
      case Activity.likedComments:
        return _userDataController.getUserLikedComments(currentUserId);
      case Activity.writtenReplies:
        return _userDataController.getUserReplies(currentUserId);
      case Activity.likedReplies:
        return _userDataController.getUserLikedReplies(currentUserId);
    }
  }

  void Function() getActivityOnPressed(dynamic activityModel) {
    switch (activity) {
      case Activity.likedPosts:
        return () => SettingsOnPressedFunctions.onLikedPostActivityPressed(
            activityModel);
      case Activity.writtenComments:
        return () => SettingsOnPressedFunctions.onCommentPostActivityPressed(
            activityModel);
      case Activity.likedComments:
        return () => SettingsOnPressedFunctions.onLikedCommentActivityPressed(
            activityModel);
      case Activity.writtenReplies:
        return () => SettingsOnPressedFunctions.onReplyCommentActivityPressed(
            activityModel);
      case Activity.likedReplies:
        return () => SettingsOnPressedFunctions.onLikedReplyActivityPressed(
            activityModel);
    }
  }

  String get currentUserId => _authenticationController.currentUserId;
  String get currentUserName => _authenticationController.currentUserName;
}
