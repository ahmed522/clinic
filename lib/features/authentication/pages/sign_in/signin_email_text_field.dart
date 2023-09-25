import 'package:clinic/features/authentication/controller/sign_in/signin_controller.dart';
import 'package:clinic/features/authentication/pages/common/email_textfield.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:flutter/material.dart';

class SigninEmailTextField extends StatelessWidget {
  const SigninEmailTextField({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = SigninController.find;
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
        controller.email = value.trim();
        return null;
      },
      onChange: (value) {
        controller.tempEmail = value;
      },
    );
  }
}
