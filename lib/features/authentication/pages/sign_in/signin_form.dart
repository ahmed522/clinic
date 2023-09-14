import 'package:clinic/features/authentication/controller/sign_in/signin_controller.dart';
import 'package:clinic/features/authentication/pages/sign_in/signin_password_textfield.dart';
import 'package:clinic/features/authentication/pages/sign_in/signin_email_text_field.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/fonts/app_fonts.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'reset_password_button.dart';

class SigninForm extends StatelessWidget {
  const SigninForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GetBuilder<SigninController>(
      builder: (controller) => Form(
        key: controller.formKey,
        child: Column(
          children: [
            const SigninEmailTextField(),
            const SizedBox(height: 20),
            const SigninPasswordTextField(),
            const ResetPasswordButton(),
            Padding(
              padding: EdgeInsets.only(top: size.height / 15),
              child: ElevatedButton(
                onPressed: controller.loading ? null : () => signin(),
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor: Colors.grey,
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      (size.width > AppConstants.phoneWidth) ? 20 : 15,
                    ),
                  ),
                ),
                child: Text(
                  "تسجيل الدخول",
                  style: TextStyle(
                    fontSize: (size.width > AppConstants.phoneWidth) ? 30 : 20,
                    fontFamily: AppFonts.mainArabicFontFamily,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // const SizedBox(height: 5),
            // const SignWithGoogle(
            //   text: AppConstants.signinWithGoogle,
            // ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  signin() {
    final controller = SigninController.find;

    if (controller.formKey.currentState!.validate()) {
      controller.updateLoading(true);
      controller.signinUser(controller.email!, controller.password!);
    }
  }
}
