import 'package:clinic/features/authentication/controller/sign_up/common/signup_controller.dart';
import 'package:clinic/features/authentication/pages/sign_up/common/personal_image_setter.dart';
import 'package:clinic/features/authentication/pages/sign_up/common/signup_main_info_form.dart';
import 'package:clinic/features/authentication/pages/sign_up/user/user_signup_page.dart';

import 'package:flutter/material.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:get/get.dart';

class MainInfoWidget extends StatelessWidget {
  final UserType userType;
  const MainInfoWidget({super.key, this.userType = UserType.doctor});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        (userType == UserType.doctor)
            ? const SizedBox()
            : GetBuilder<SignupController>(
                tag: UserSignupPage.route,
                builder: (controller) {
                  return controller.loading
                      ? const LinearProgressIndicator()
                      : const SizedBox();
                }),
        Center(
          child: SingleChildScrollView(
            padding: (userType == UserType.user)
                ? const EdgeInsets.only(right: 20, left: 20)
                : const EdgeInsets.all(0),
            child: Column(
              children: [
                PersonalImageSetter(
                  userType: userType,
                ),
                const SizedBox(height: 40),
                SignupMainInfoForm(
                  userType: userType,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
