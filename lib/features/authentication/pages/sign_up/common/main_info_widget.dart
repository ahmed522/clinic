import 'package:clinic/features/authentication/pages/sign_up/common/personal_image_setter.dart';
import 'package:clinic/features/authentication/pages/sign_up/common/signup_main_info_form.dart';

import 'package:flutter/material.dart';
import 'package:clinic/global/constants/user_type.dart';

class MainInfoWidget extends StatelessWidget {
  final UserType userType;
  const MainInfoWidget({super.key, this.userType = UserType.doctor});

  @override
  Widget build(BuildContext context) {
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
