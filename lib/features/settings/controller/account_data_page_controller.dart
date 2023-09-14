import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/authentication/controller/local_storage_controller.dart';
import 'package:clinic/features/notifications/controller/notifications_controller.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:get/get.dart';

class AccountDataPageController extends GetxController {
  static AccountDataPageController get find => Get.find();
  final AuthenticationController _authenticationController =
      AuthenticationController.find;
  bool loading = false;
  bool ergentCasesNotifications =
      NotificationsController.find.notifyWhenErgentCases;

  updateErgentCasesNotifications(bool value) {
    ergentCasesNotifications = value;
    LocalStorageController.find.updateNotificationsSettings(value);
    update();
  }

  UserType get currentUserType => _authenticationController.currentUserType;
  String get currentUserId => _authenticationController.currentUserId;
}
