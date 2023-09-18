import 'package:clinic/features/authentication/controller/sign_up/common/signup_controller.dart';
import 'package:clinic/features/authentication/controller/sign_up/doctor/doctor_signup_controller.dart';
import 'package:clinic/features/authentication/pages/sign_up/doctor/doctor_signup_parent.dart';
import 'package:clinic/features/clinic/controller/single_clinic_controller.dart';
import 'package:clinic/features/clinic/pages/creation/clinic_phone_number_text_field.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/constants/clinic_page_mode.dart';
import 'package:clinic/global/widgets/circle_button.dart';
import 'package:clinic/global/widgets/circular_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetClinicPhoneNumbersWidget extends StatelessWidget {
  const SetClinicPhoneNumbersWidget({
    super.key,
    required this.clinicIndex,
    required this.mode,
  });
  final int clinicIndex;
  final ClinicPageMode mode;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'أرقام الهواتف',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        (mode == ClinicPageMode.signupMode)
            ? GetBuilder<SignupController>(
                tag: DoctorSignUpParent.route,
                builder: (controller) {
                  if ((controller as DoctorSignupController)
                      .clinicsPhoneNumbersTextControllers[clinicIndex]
                      .isEmpty) {
                    return CircleButton(
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      onPressed: () =>
                          controller.addNewPhoneNumber(clinicIndex),
                    );
                  }
                  return SingleChildScrollView(
                    child: Column(
                      children: List<Widget>.generate(
                        controller
                            .clinicsPhoneNumbersTextControllers[clinicIndex]
                            .length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 3.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ClinicPhoneNumberTextField(
                                mode: mode,
                                clinicIndex: clinicIndex,
                                index: index,
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => controller.removePhoneNumber(
                                        clinicIndex, index),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black38,
                                            spreadRadius: 0.3,
                                            blurRadius: 1,
                                            offset: Offset(0, 0.3),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  (index ==
                                          controller
                                                  .clinicsPhoneNumbersTextControllers[
                                                      clinicIndex]
                                                  .length -
                                              1)
                                      ? GestureDetector(
                                          onTap: () => controller
                                              .addNewPhoneNumber(clinicIndex),
                                          child: Container(
                                            padding: const EdgeInsets.all(5.0),
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColors.primaryColor,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black38,
                                                  spreadRadius: 0.5,
                                                  blurRadius: 1,
                                                  offset: Offset(0, 0.5),
                                                ),
                                              ],
                                            ),
                                            child: const Icon(
                                              Icons.add,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            : GetBuilder<SingleClinicController>(
                builder: (controller) {
                  if (controller.clinicsPhoneNumbersTextControllers.isEmpty) {
                    return CircleButton(
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      onPressed: () => controller.addNewPhoneNumber(),
                    );
                  }
                  return SingleChildScrollView(
                    child: Column(
                      children: List<Widget>.generate(
                        controller.clinicsPhoneNumbersTextControllers.length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 3.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ClinicPhoneNumberTextField(
                                mode: mode,
                                clinicIndex: clinicIndex,
                                index: index,
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () =>
                                        controller.removePhoneNumber(index),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black38,
                                            spreadRadius: 0.3,
                                            blurRadius: 1,
                                            offset: Offset(0, 0.3),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  (index ==
                                          controller
                                                  .clinicsPhoneNumbersTextControllers
                                                  .length -
                                              1)
                                      ? GestureDetector(
                                          onTap: () =>
                                              controller.addNewPhoneNumber(),
                                          child: Container(
                                            padding: const EdgeInsets.all(8.0),
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColors.primaryColor,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black38,
                                                  spreadRadius: 0.5,
                                                  blurRadius: 1,
                                                  offset: Offset(0, 0.5),
                                                ),
                                              ],
                                            ),
                                            child: const Icon(
                                              Icons.add,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }
}
