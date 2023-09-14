import 'package:clinic/features/authentication/controller/sign_in/signin_controller.dart';
import 'package:clinic/features/authentication/pages/common/password_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SigninPasswordTextField extends StatelessWidget {
  const SigninPasswordTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SigninController>(
      builder: (controller) {
        return PasswordTextField(
          showPassword: controller.showPassword,
          validator: (value) {
            if (value == null || value.trim() == '') {
              return 'من فضلك ادخل كلمة المرور';
            }
            controller.password = value;
            return null;
          },
          onShowPasswordButtonPressed: () => controller.updateShowPassword(),
        );
      },
    );
  }
}
