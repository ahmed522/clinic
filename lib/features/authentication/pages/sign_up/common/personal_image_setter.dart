import 'dart:io';

import 'package:clinic/features/authentication/controller/sign_up/common/signup_controller.dart';
import 'package:clinic/features/authentication/controller/sign_up/doctor/doctor_signup_controller.dart';
import 'package:clinic/features/authentication/controller/sign_up/user/user_signup_controller.dart';
import 'package:clinic/features/authentication/pages/sign_up/doctor/doctor_signup_parent.dart';
import 'package:clinic/features/authentication/pages/sign_up/user/user_signup_page.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:clinic/global/widgets/image_source_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonalImageSetter extends StatelessWidget {
  const PersonalImageSetter({
    Key? key,
    required this.userType,
  }) : super(key: key);

  final UserType userType;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            MyAlertDialog.getInfoAlertDialog(
              context,
              'الصورة الشخصية',
              AppConstants.whyPersonalImage,
              {
                'أعي ذلك': () => Navigator.of(context).pop(),
              },
            ),
            Text(
              ' الصورة الشخصية',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Stack(alignment: Alignment.center, children: [
          GetBuilder<SignupController>(
              tag: userType == UserType.doctor
                  ? DoctorSignUpParent.route
                  : UserSignupPage.route,
              builder: (controller) {
                bool personalImageIsNotNull = false;
                if (userType == UserType.doctor) {
                  personalImageIsNotNull =
                      (controller as DoctorSignupController)
                              .doctorModel
                              .personalImage !=
                          null;
                } else {
                  personalImageIsNotNull = (controller as UserSignupController)
                          .userModel
                          .personalImage !=
                      null;
                }
                if (personalImageIsNotNull) {
                  return Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primaryColor,
                          width: 3,
                        ),
                        shape: BoxShape.circle),
                    child: CircleAvatar(
                      backgroundImage: FileImage(
                        File(userType == UserType.doctor
                            ? (controller as DoctorSignupController)
                                .doctorModel
                                .personalImage!
                                .path
                            : (controller as UserSignupController)
                                .userModel
                                .personalImage!
                                .path),
                      ),
                      radius: 80,
                    ),
                  );
                } else {
                  return Image.asset(
                    'assets/img/user.png',
                  );
                }
              }),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: IconButton(
                    padding: const EdgeInsets.all(0),
                    iconSize: 25,
                    onPressed: () {
                      showModalBottomSheet<dynamic>(
                          enableDrag: false,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(35))),
                          context: context,
                          builder: (context) => Padding(
                                padding: MediaQuery.of(context).viewInsets,
                                child: GetBuilder<SignupController>(
                                    tag: userType == UserType.doctor
                                        ? DoctorSignUpParent.route
                                        : UserSignupPage.route,
                                    builder: (controller) {
                                      return Wrap(children: [
                                        ImageSourcePage()
                                          ..onPressed = (image) {
                                            if (image != null) {
                                              if (userType == UserType.doctor) {
                                                (controller
                                                        as DoctorSignupController)
                                                    .setPersonalImage(
                                                        File(image.path));
                                                controller
                                                    .validatePersonalImage(
                                                        true);
                                              } else {
                                                (controller
                                                        as UserSignupController)
                                                    .setPersonalImage(
                                                        File(image.path));
                                              }
                                            }
                                            Get.back();
                                          }
                                      ]);
                                    }),
                              ));
                    },
                    icon: const Icon(Icons.add, color: Colors.white)),
              ),
            ),
          ),
        ]),
        const SizedBox(height: 20),
        (userType == UserType.doctor)
            ? GetBuilder<SignupController>(
                tag: DoctorSignUpParent.route,
                builder: (controller) {
                  return Text(
                    (controller as DoctorSignupController)
                        .personalImageValidation,
                    style: const TextStyle(
                      fontFamily: AppFonts.mainArabicFontFamily,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Colors.red,
                    ),
                  );
                })
            : const SizedBox(),
      ],
    );
  }
}
