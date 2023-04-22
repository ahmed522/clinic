import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/authentication/controller/sign_in/signin_controller.dart';
import 'package:clinic/features/authentication/pages/common/sign_with_google.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/fonts/app_fonst.dart';

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
        init: SigninController(),
        builder: (controller) => Form(
              key: controller.formKey,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'البريد الإلكتروني',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'من فضلك ادخل البريد الإلكتروني';
                      } else {
                        final bool emailValid =
                            RegExp(AppConstants.emailValidationRegExp)
                                .hasMatch(value);
                        if (!emailValid) {
                          return 'من فضلك ادخل بريد إلكتروني صحيح';
                        }
                      }
                      controller.email = value.trim();
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      icon: Icon(Icons.email_rounded),
                      hintText: 'Enter your Email',
                    ),
                  ),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'كلمة المرور',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.trim() == '') {
                        return 'من فضلك ادخل كلمة المرور ';
                      }
                      controller.password = value;
                      return null;
                    },
                    keyboardType: TextInputType.visiblePassword,
                    enableSuggestions: false,
                    autocorrect: false,
                    obscureText: !controller.showPassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      icon: const Icon(Icons.password_rounded),
                      hintText: 'Enter your Password',
                      suffixIcon: IconButton(
                        icon: (controller.showPassword)
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                        onPressed: () => controller.updateShowPassword(),
                      ),
                    ),
                  ),
                  const ResetPasswordButton(),

                  Padding(
                    padding: EdgeInsets.only(top: size.height / 15),
                    child: ElevatedButton(
                      onPressed: () {
                        if (controller.formKey.currentState!.validate()) {
                          controller.signinUser(
                              controller.email!, controller.password!);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                (size.width > AppConstants.phoneWidth)
                                    ? 20
                                    : 15),
                          )),
                      child: Text(
                        "تسجيل الدخول",
                        style: TextStyle(
                            fontSize: (size.width > AppConstants.phoneWidth)
                                ? 30
                                : 20,
                            fontFamily: AppFonts.mainArabicFontFamily,
                            color: Colors.white),
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
            ));
  }
}
