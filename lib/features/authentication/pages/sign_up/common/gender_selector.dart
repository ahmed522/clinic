import 'package:clinic/features/authentication/controller/sign_up/common/signup_controller.dart';
import 'package:clinic/features/authentication/controller/sign_up/doctor/doctor_signup_controller.dart';
import 'package:clinic/features/authentication/controller/sign_up/user/user_signup_controller.dart';
import 'package:clinic/features/authentication/pages/sign_up/doctor/doctor_signup_parent.dart';
import 'package:clinic/features/authentication/pages/sign_up/user/user_signup_page.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:flutter/material.dart';

import 'package:clinic/global/constants/gender.dart';

import 'package:clinic/global/widgets/circular_icon_button.dart';
import 'package:get/get.dart';

class GenderSelectorWidget extends StatelessWidget {
  const GenderSelectorWidget({
    super.key,
    required this.userType,
  });
  final UserType userType;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'النوع',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0, right: 8.0, left: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GetBuilder<SignupController>(
                  tag: userType == UserType.doctor
                      ? DoctorSignUpParent.route
                      : UserSignupPage.route,
                  builder: (controller) {
                    return CircularIconButton(
                      onPressed: () {
                        if (userType == UserType.doctor) {
                          (controller as DoctorSignupController)
                              .updateGender(Gender.male);
                        } else {
                          (controller as UserSignupController)
                              .updateGender(Gender.male);
                        }
                      },
                      selected: userType == UserType.doctor
                          ? ((controller as DoctorSignupController)
                                  .doctorModel
                                  .gender ==
                              Gender.male)
                          : ((controller as UserSignupController)
                                  .userModel
                                  .gender ==
                              Gender.male),
                      child: const Icon(
                        Icons.man,
                      ),
                    );
                  }),
              GetBuilder<SignupController>(
                  tag: userType == UserType.doctor
                      ? DoctorSignUpParent.route
                      : UserSignupPage.route,
                  builder: (controller) {
                    return CircularIconButton(
                      onPressed: () {
                        if (userType == UserType.doctor) {
                          (controller as DoctorSignupController)
                              .updateGender(Gender.female);
                        } else {
                          (controller as UserSignupController)
                              .updateGender(Gender.female);
                        }
                      },
                      selected: userType == UserType.doctor
                          ? ((controller as DoctorSignupController)
                                  .doctorModel
                                  .gender ==
                              Gender.female)
                          : ((controller as UserSignupController)
                                  .userModel
                                  .gender ==
                              Gender.female),
                      child: const Icon(
                        Icons.woman,
                      ),
                    );
                  }),
            ],
          ),
        )
      ],
    );
  }
}
