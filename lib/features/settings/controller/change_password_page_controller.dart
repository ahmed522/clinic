import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordPageController extends GetxController {
  static ChangePasswordPageController get find => Get.find();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AuthenticationController _authenticationController =
      AuthenticationController.find;
  bool loading = false;
  bool showOldPassword = false;
  bool showNewPassword = false;
  late String oldPassword;
  late String newPassword;

  updateShowOldPassword() {
    showOldPassword = !showOldPassword;
    update();
  }

  updateShowNewPassword() {
    showNewPassword = !showNewPassword;
    update();
  }

  oldPasswordValidator(String? value) {
    if (value == null || value.trim() == '') {
      return 'من فضلك ادخل كلمة المرور';
    }
    oldPassword = value;
    return null;
  }

  newPasswordValidator(String? value) {
    if (value == null) {
      return 'من فضلك ادخل كلمة المرور ';
    } else if (value.length < AppConstants.passwordLength) {
      return 'كلمة المرور لا يجب أن تقل عن ثمانية أحرف';
    } else if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'كلمة المرور يجب أن تحتوي على أحرف كبيرة';
    } else if (!value.contains(RegExp(r'[a-z]'))) {
      return 'كلمة المرور يجب أن تحتوي على أحرف صغيرة';
    } else if (!value.contains(RegExp(r'[0-9]'))) {
      return 'كلمة المرور يجب أن تحتوي على أرقام';
    }
    newPassword = value;
    return null;
  }

  changePassword() async {
    updateLoading(true);
    await _changePassword();
    updateLoading(false);
  }

  updateLoading(bool value) {
    loading = value;
    update();
  }

  Future _changePassword() =>
      _authenticationController.changePassword(oldPassword, newPassword);
}
