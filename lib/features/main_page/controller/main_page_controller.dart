import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class MainPageController extends GetxController {
  static MainPageController get find => Get.find();
  final AuthenticationController _authenticationController =
      AuthenticationController.find;
  final UserDataController _userDataController = UserDataController.find;
  RxBool newNotifications = false.obs;
  PageController pageController = PageController(initialPage: 3);
  RxInt selectedPage = 3.obs;
  @override
  onReady() async {
    newNotifications.value =
        await _userDataController.isNewNotifications(currentUserId);
    newNotifications.bindStream(_newNotificationsListener);
    super.onReady();
  }

  Stream<bool> get _newNotificationsListener => Stream.periodic(
        const Duration(minutes: 2),
        (_) {
          _userDataController
              .isNewNotifications(currentUserId)
              .then((value) => newNotifications.value = value);
          return newNotifications.value;
        },
      );

  UserType get currentUserType => _authenticationController.currentUserType;
  String get currentUserId => _authenticationController.currentUserId;
  String get currentUserName => _authenticationController.currentUserName;
  String? get currentUserPersonalImage =>
      _authenticationController.currentUserPersonalImage;
  Gender get currentUserGender => _authenticationController.currentUserGender;
}
