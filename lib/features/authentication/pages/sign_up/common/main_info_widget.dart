import 'package:clinic/features/authentication/controller/sign_up/common/signup_controller.dart';
import 'package:clinic/features/authentication/controller/sign_up/doctor/doctor_signup_controller.dart';
import 'package:clinic/features/authentication/controller/sign_up/user/user_signup_controller.dart';
import 'package:clinic/features/authentication/pages/sign_up/common/personal_image_setter.dart';
import 'package:clinic/features/authentication/pages/sign_up/common/signup_main_info_form.dart';
import 'package:clinic/features/authentication/pages/sign_up/doctor/doctor_signup_page.dart';
import 'package:clinic/features/authentication/pages/sign_up/user/user_signup_page.dart';

import 'package:flutter/material.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:get/get.dart';

class MainInfoWidget extends StatelessWidget {
  final UserType userType;
  const MainInfoWidget({super.key, this.userType = UserType.doctor});

  @override
  Widget build(BuildContext context) {
    final controller = Get.lazyPut(
      (userType == UserType.user)
          ? () => UserSignupController()
          : () => DoctorSignupController(),
      tag: (userType == UserType.user)
          ? UserSignupPage.route
          : DoctorSignupPage.route,
    );
    print("54444");
    return Center(
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
    );
  }
}
