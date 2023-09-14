import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/features/notifications/controller/notification_on_pressed_functions.dart';
import 'package:clinic/features/notifications/model/notification_model.dart';
import 'package:clinic/features/notifications/model/notification_type.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/data/models/parent_user_model.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/error_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class NotificationPageController extends GetxController {
  static NotificationPageController get find => Get.find();
  final AuthenticationController _authenticationController =
      AuthenticationController.find;
  final UserDataController _userDataController = UserDataController.find;
  RxBool loading = true.obs;
  RxBool moreNotificaionsLoading = true.obs;
  RxBool noMoreNotifications = false.obs;
  DocumentSnapshot? _lastNotificationShown;
  RxList<NotificationModel> notifications = <NotificationModel>[].obs;

  @override
  onReady() {
    loadNotifications(50, true);
    super.onReady();
  }

  Future<void> loadNotifications(int limit, bool isRefresh) async {
    if (isRefresh) {
      loading.value = true;
    }
    moreNotificaionsLoading.value = true;
    try {
      QuerySnapshot snapshot;
      if (isRefresh) {
        snapshot = await _userDataController
            .getUserNotificationsCollectionById(currentUserId)
            .orderBy('time', descending: true)
            .limit(limit)
            .get()
            .then(
          (snapshot) async {
            for (var documentSnapshot in snapshot.docs) {
              if (_isOldNotification(documentSnapshot)) {
                String notificationId = documentSnapshot.id;
                snapshot.docs.remove(documentSnapshot);
                await _userDataController
                    .getSingleNotificationDocumentById(
                        currentUserId, notificationId)
                    .delete();
              }
            }
            return snapshot;
          },
        );
      } else {
        snapshot = await _userDataController
            .getUserNotificationsCollectionById(currentUserId)
            .orderBy('time', descending: true)
            .startAfterDocument(_lastNotificationShown!)
            .limit(limit)
            .get()
            .then(
          (snapshot) async {
            for (var documentSnapshot in snapshot.docs) {
              if (_isOldNotification(documentSnapshot)) {
                String notificationId = documentSnapshot.id;
                snapshot.docs.remove(documentSnapshot);
                await _userDataController
                    .getSingleNotificationDocumentById(
                        currentUserId, notificationId)
                    .delete();
              }
            }
            return snapshot;
          },
        );
      }
      if (snapshot.size < limit) {
        noMoreNotifications.value = true;
      } else {
        noMoreNotifications.value = false;
      }
      if (snapshot.size == 0) {
        if (isRefresh) {
          notifications.clear();
        }
        loading.value = false;
        moreNotificaionsLoading.value = false;
        return;
      }
      _showNotifications(snapshot, isRefresh);
    } catch (e) {
      loading.value = false;
      moreNotificaionsLoading.value = false;
      Get.off(
        () => const ErrorPage(
          imageAsset: 'assets/img/error.svg',
          message: 'حدثت مشكلة نعمل على حلها الان، يرجى إعادة المحاولة لاحقاً',
        ),
      );
    }
  }

  _showNotifications(QuerySnapshot snapshot, bool isRefresh) async {
    if (isRefresh) {
      notifications.clear();
    } else {
      notifications.removeRange(0, notifications.length ~/ 2);
    }
    _lastNotificationShown = snapshot.docs.last;

    for (var notificationSnapshot in snapshot.docs) {
      NotificationModel notification =
          NotificationModel.fromSnapshot(notificationSnapshot);
      notification.notifierPic =
          await _userDataController.getUserPersonalImageURLById(
              notification.notifierId, notification.notifierType);
      notifications.add(notification);
      loading.value = false;
    }
    moreNotificaionsLoading.value = false;
  }

  updateSeenedNotification(String notificationId) async {
    await _userDataController.updateNotificationSeen(
        currentUserId, notificationId);
  }

  bool _isOldNotification(DocumentSnapshot notificationSnapshot) {
    bool isOldNotification = false;
    int notificationTimeDifferenceInDays =
        CommonFunctions.calculateTimeDifferenceInDays(
            notificationSnapshot['time'].toDate(), DateTime.now());
    int notificationSeenTimeDifferenceInDays = 0;
    if (notificationSnapshot['seen']) {
      notificationSeenTimeDifferenceInDays =
          CommonFunctions.calculateTimeDifferenceInDays(
              notificationSnapshot['seen_time'].toDate(), DateTime.now());
    }
    if ((notificationSnapshot['seen'] &&
            notificationSeenTimeDifferenceInDays >= 3) ||
        (notificationTimeDifferenceInDays >= 10)) {
      isOldNotification = true;
    }
    return isOldNotification;
  }

  void Function() getNotificationOnPressed(NotificationModel notification) {
    switch (notification.type) {
      case NotificationType.newFollow:
        return () =>
            NotificationsOnPressedFunctions.newFollowNotificationOnPressed(
                notification);
      case NotificationType.reactMyPost:
        return () =>
            NotificationsOnPressedFunctions.reactMyPostNotificationOnPressed(
                notification);
      case NotificationType.reactMyComment:
        return () =>
            NotificationsOnPressedFunctions.reactMyCommentNotificationOnPressed(
                notification);
      case NotificationType.reactMyReply:
        return () =>
            NotificationsOnPressedFunctions.reactMyReplyNotificationOnPressed(
                notification);
      case NotificationType.commentMyPost:
        return () =>
            NotificationsOnPressedFunctions.commentMyPostNotificationOnPressed(
                notification);
      case NotificationType.commentOnPostICommented:
        return () => NotificationsOnPressedFunctions
            .commentOnPostICommentedNotificationOnPressed(notification);
      case NotificationType.replyMyComment:
        return () =>
            NotificationsOnPressedFunctions.replyMyCommentNotificationOnPressed(
                notification);
      case NotificationType.replyOnMyPost:
        return () =>
            NotificationsOnPressedFunctions.replyOnMyPostNotificationOnPressed(
                notification);
      case NotificationType.replyOnCommentIReplied:
        return () => NotificationsOnPressedFunctions
            .replyOnCommentIRepliedNotificationOnPressed(notification);
      case NotificationType.searchingForMySpecialization:
        return () => NotificationsOnPressedFunctions
            .searchingForMySpecializationNotificationOnPressed(notification);
      case NotificationType.followedDoctorPost:
      case NotificationType.followedDoctorNewClinicPost:
      case NotificationType.followedDoctorDiscountPost:
      case NotificationType.followedDoctorMedicalInfoPost:
      case NotificationType.followedDoctorNewDegreePost:
        return () => NotificationsOnPressedFunctions
            .followedDoctorPostNotificationOnPressed(notification);
    }
  }

  ParentUserModel get currentUser => _authenticationController.currentUser;
  UserType get currentUserType => _authenticationController.currentUserType;
  String get currentUserId => _authenticationController.currentUserId;
  String get currentUserName => _authenticationController.currentUserName;
  String? get currentUserPersonalImage =>
      _authenticationController.currentUserPersonalImage;
  Gender get currentUserGender => _authenticationController.currentUserGender;
}
