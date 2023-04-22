import 'dart:io';

import 'package:clinic/features/authentication/controller/sign_up/common/signup_controller.dart';
import 'package:clinic/features/authentication/model/user_model.dart';
import 'package:clinic/global/constants/gender.dart';
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

  @override
  updateAge(int age) {
    userModel.age = age;

    update();
  }
}
