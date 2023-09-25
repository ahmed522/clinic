import 'package:clinic/features/authentication/controller/sign_up/common/signup_controller.dart';
import 'package:clinic/features/authentication/controller/sign_up/doctor/doctor_signup_controller.dart';
import 'package:clinic/features/authentication/controller/sign_up/user/user_signup_controller.dart';
import 'package:clinic/features/authentication/pages/common/email_textfield.dart';
import 'package:clinic/features/authentication/pages/sign_up/doctor/doctor_signup_parent.dart';
import 'package:clinic/features/authentication/pages/sign_up/user/user_signup_page.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupEmailTextField extends StatelessWidget {
  const SignupEmailTextField({
    Key? key,
    required this.userType,
  }) : super(key: key);
  final UserType userType;
  @override
  Widget build(BuildContext context) {
    final SignupController controller = Get.find(
      tag: userType == UserType.doctor
          ? DoctorSignUpParent.route
          : UserSignupPage.route,
    );
    return EmailTextField(
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'من فضلك ادخل البريد الإلكتروني';
        } else {
          final bool emailValid =
              RegExp(AppConstants.emailValidationRegExp).hasMatch(value);
          if (!emailValid) {
            return 'من فضلك ادخل بريد إلكتروني صحيح';
          }
        }
        if (userType == UserType.user) {
          (controller as UserSignupController).userModel.email = value.trim();
        } else {
          (controller as DoctorSignupController).doctorModel.email =
              value.trim();
        }
        return null;
      },
      onChange: (value) {},
    );
  }
}
