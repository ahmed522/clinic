import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SigninController extends GetxController {
  static SigninController get find => Get.find();
  bool loading = false;
  String? email;
  String? password;
  bool showPassword = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  updateShowPassword() {
    showPassword = !showPassword;
    update();
  }

  updateLoading(bool value) {
    loading = value;
    update();
  }

  signinUser(String email, String password) {
    AuthenticationController.find.signInWithEmailAndPassword(email, password);
  }

  resetPassword(String email) {
    AuthenticationController.find.restPassword(email);
  }
}
