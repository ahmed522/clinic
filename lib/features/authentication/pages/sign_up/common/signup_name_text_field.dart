import 'package:clinic/features/authentication/controller/sign_up/common/signup_controller.dart';
import 'package:clinic/features/authentication/controller/sign_up/doctor/doctor_signup_controller.dart';
import 'package:clinic/features/authentication/controller/sign_up/user/user_signup_controller.dart';
import 'package:clinic/features/authentication/pages/common/name_text_field.dart';
import 'package:clinic/features/authentication/pages/sign_up/doctor/doctor_signup_parent.dart';
import 'package:clinic/features/authentication/pages/sign_up/user/user_signup_page.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupNameTextField extends StatelessWidget {
  const SignupNameTextField({
    Key? key,
    required this.userType,
    required this.text,
  }) : super(key: key);

  final UserType userType;
  final String text;
  @override
  Widget build(BuildContext context) {
    final SignupController controller = Get.find(
      tag: userType == UserType.doctor
          ? DoctorSignUpParent.route
          : UserSignupPage.route,
    );
    return NameTextField(
      text: text,
      getName: (validatedName) {
        if (userType == UserType.doctor) {
          if (text == 'الأول') {
            (controller as DoctorSignupController).doctorModel.firstName =
                validatedName;
          } else {
            (controller as DoctorSignupController).doctorModel.lastName =
                validatedName;
          }
        } else {
          if (text == 'الأول') {
            (controller as UserSignupController).userModel.firstName =
                validatedName;
          } else {
            (controller as UserSignupController).userModel.lastName =
                validatedName;
          }
        }
      },
    );
  }
}
