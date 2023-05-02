import 'dart:io';

import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/data/models/doctor_model.dart';
import 'package:clinic/global/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  bool showPassword = false;
  static SignupController get find => Get.find();
  bool loading = false;
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

  updateLoading(bool value) {
    loading = value;
    update();
  }

  signupDoctor(DoctorModel doctorModel) {
    AuthenticationController.find.createDoctorWithEmailAndPassword(doctorModel);
  }

  signupUser(UserModel userModel) async {
    await AuthenticationController.find
        .createUserWithEmailAndPassword(userModel);
    updateLoading(false);
  }
}
