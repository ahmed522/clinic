import 'package:clinic/features/authentication/controller/sign_up/common/signup_controller.dart';
import 'package:clinic/features/authentication/controller/sign_up/doctor/doctor_signup_controller.dart';
import 'package:clinic/features/authentication/controller/sign_up/user/user_signup_controller.dart';
import 'package:clinic/features/authentication/pages/common/password_textfield.dart';
import 'package:clinic/features/authentication/pages/sign_up/doctor/doctor_signup_parent.dart';
import 'package:clinic/features/authentication/pages/sign_up/user/user_signup_page.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupPasswordTextField extends StatelessWidget {
  const SignupPasswordTextField({
    Key? key,
    required this.userType,
  }) : super(key: key);
  final UserType userType;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignupController>(
      tag: userType == UserType.doctor
          ? DoctorSignUpParent.route
          : UserSignupPage.route,
      builder: (controller) {
        return PasswordTextField(
          showPassword: controller.showPassword,
          validator: (value) {
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
            if (userType == UserType.doctor) {
              (controller as DoctorSignupController).doctorModel.setPassword =
                  value;
            } else {
              (controller as UserSignupController).userModel.setPassword =
                  value;
            }
            return null;
          },
          onShowPasswordButtonPressed: () => controller.updateShowPassword(),
        );
      },
    );
  }
}
