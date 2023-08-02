import 'package:clinic/features/authentication/controller/sign_up/common/signup_controller.dart';
import 'package:clinic/features/authentication/controller/sign_up/doctor/doctor_signup_controller.dart';
import 'package:clinic/features/authentication/pages/sign_up/doctor/doctor_signup_parent.dart';
import 'package:clinic/features/clinic/controller/single_clinic_controller.dart';
import 'package:clinic/features/clinic/pages/creation/clinic_location_text_field.dart';
import 'package:clinic/features/clinic/pages/creation/clinic_use_current_location_button.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/constants/clinic_page_mode.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetClinicLocationWidget extends StatelessWidget {
  const SetClinicLocationWidget({
    Key? key,
    required this.index,
    required this.mode,
  }) : super(key: key);

  final int index;
  final ClinicPageMode mode;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            (mode == ClinicPageMode.signupMode)
                ? GetX<SignupController>(
                    tag: DoctorSignUpParent.route,
                    builder: (controller) {
                      if ((controller as DoctorSignupController)
                          .locationValidation
                          .isTrue) {
                        return const Icon(Icons.done_rounded,
                            color: Colors.green);
                      } else {
                        return const Icon(
                          Icons.close_rounded,
                          color: Colors.red,
                        );
                      }
                    })
                : GetX<SingleClinicController>(builder: (controller) {
                    if (controller.locationValidation.isTrue) {
                      return const Icon(Icons.done_rounded,
                          color: Colors.green);
                    } else {
                      return const Icon(
                        Icons.close_rounded,
                        color: Colors.red,
                      );
                    }
                  }),
            const SizedBox(
              width: 10,
            ),
            Text(
              'موقع العيادة',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        (mode == ClinicPageMode.signupMode)
            ? GetBuilder<SignupController>(
                tag: DoctorSignUpParent.route,
                builder: (controller) {
                  return ClinicLocationTextField(
                    onChanged: (value) => (controller as DoctorSignupController)
                        .updateClinicLocationFromTextField(value, index),
                  );
                },
              )
            : GetBuilder<SingleClinicController>(
                builder: (controller) {
                  return ClinicLocationTextField(
                    initialText: controller.tempClinic.location,
                    onChanged: (value) =>
                        controller.updateClinicLocationFromTextField(value),
                  );
                },
              ),
        const SizedBox(
          height: 5,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              (mode == ClinicPageMode.signupMode)
                  ? GetBuilder<SignupController>(
                      tag: DoctorSignUpParent.route,
                      builder: (controller) {
                        return ClinicUseCurrentLocationButton(
                          onPressed: ((controller as DoctorSignupController)
                                      .clinicLocationLoading ||
                                  controller.loading)
                              ? null
                              : () async =>
                                  await controller.getCurrentLocation(index),
                          clinicLocationLoading:
                              controller.clinicLocationLoading,
                        );
                      },
                    )
                  : GetBuilder<SingleClinicController>(
                      builder: (controller) {
                        return ClinicUseCurrentLocationButton(
                          onPressed: (controller.clinicLocationLoading ||
                                  controller.loading)
                              ? null
                              : () async =>
                                  await controller.getCurrentLocation(),
                          clinicLocationLoading:
                              controller.clinicLocationLoading,
                        );
                      },
                    ),
              const SizedBox(
                width: 10,
              ),
              Text(
                'أو',
                style: TextStyle(
                  color: (CommonFunctions.isLightMode(context))
                      ? AppColors.darkThemeBackgroundColor
                      : Colors.white,
                  fontFamily: AppFonts.mainArabicFontFamily,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
