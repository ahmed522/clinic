import 'dart:io';

import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  bool showPassword = false;
  static SignupController get find => Get.find();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  setPersonalImage(File image) {
    update();
  }

  updateShowPassword() {
    showPassword = !showPassword;
    update();
  }

  updateGender(Gender gender) {
    update();
  }

  updateAge(int age) {
    update();
  }

  signupUser(String email, String password) {
    AuthenticationController.find
        .createUserWithEmailAndPassword(email, password);
  }
}
