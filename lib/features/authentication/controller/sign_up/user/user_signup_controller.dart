import 'dart:io';

import 'package:clinic/features/authentication/controller/sign_up/common/signup_controller.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserSignupController extends SignupController {
  static UserSignupController get find => Get.find();
  UserModel userModel = UserModel();

  @override
  setPersonalImage(File image) {
    userModel.personalImage = image;

    update();
  }

  @override
  updateGender(Gender gender) {
    userModel.gender = gender;

    update();
  }

  onSignupUserButtonPressed() {
    if (formKey.currentState!.validate() && ageIsValid) {
      updateLoading(true);
      signupUser(userModel);
    }
  }

  @override
  pickBirthDate(BuildContext context) async {
    DateTime? birthDate = await showDatePicker(
        context: context,
        initialDate: userModel.birthDate.toDate(),
        firstDate: DateTime(1940),
        lastDate: DateTime.now());
    if (birthDate != null) {
      userModel.birthDate = Timestamp.fromDate(birthDate);
    }
    ageIsValid = validateBirthDate();
    update();
  }

  @override
  bool validateBirthDate() {
    if (userModel.birthDate.toDate().year >
        AppConstants.userMinimumBirthDateYear) {
      return false;
    }
    return true;
  }
}
