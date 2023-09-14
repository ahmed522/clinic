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
  final AuthenticationController _authenticationController =
      AuthenticationController.find;
  bool ageIsValid = false;
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

  updateLoading(bool value) {
    loading = value;
    update();
  }

  Future signupDoctor(DoctorModel doctorModel) =>
      _authenticationController.createDoctorWithEmailAndPassword(doctorModel);

  signupUser(UserModel userModel) async {
    await _authenticationController.createUserWithEmailAndPassword(userModel);
    updateLoading(false);
  }

  pickBirthDate(BuildContext context) async {
    update();
  }

  bool validateBirthDate() {
    return false;
  }
}
