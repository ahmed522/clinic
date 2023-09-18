import 'package:clinic/features/authentication/controller/sign_up/common/signup_controller.dart';
import 'package:clinic/features/authentication/controller/sign_up/doctor/doctor_signup_controller.dart';
import 'package:clinic/features/authentication/pages/sign_up/doctor/doctor_signup_parent.dart';
import 'package:clinic/features/clinic/controller/single_clinic_controller.dart';
import 'package:clinic/features/clinic/pages/creation/set_clinic_time_content_widget.dart';
import 'package:clinic/global/constants/clinic_page_mode.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetClinicTimeWidget extends StatelessWidget {
  const SetClinicTimeWidget({
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
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'ساعات العمل',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        (mode == ClinicPageMode.signupMode)
            ? GetBuilder<SignupController>(
                tag: DoctorSignUpParent.route,
                builder: (controller) {
                  return SetClinicTimeContentWidget(
                    openTimeText: CommonFunctions.getTime(
                      (controller as DoctorSignupController)
                          .doctorModel
                          .clinics[index]
                          .openTime,
                    ),
                    closeTimeText: CommonFunctions.getTime(
                        controller.doctorModel.clinics[index].closeTime),
                    onOpenTimeButtonPressed: controller.loading
                        ? null
                        : () async {
                            TimeOfDay? picked;
                            picked = await showTimePicker(
                              context: context,
                              initialTime:
                                  CommonFunctions.timeOfDayFromTimestamp(
                                      controller
                                          .doctorModel.clinics[index].openTime),
                            );
                            controller.doctorModel.clinics[index].openTime =
                                (picked == null)
                                    ? controller
                                        .doctorModel.clinics[index].openTime
                                    : CommonFunctions.timestampFromTimeOfDay(
                                        picked);
                            controller.update();
                          },
                    onCloseTimeButtonPressed: controller.loading
                        ? null
                        : () async {
                            TimeOfDay? picked;
                            picked = await showTimePicker(
                              context: context,
                              initialTime:
                                  CommonFunctions.timeOfDayFromTimestamp(
                                      controller.doctorModel.clinics[index]
                                          .closeTime),
                            );
                            controller.doctorModel.clinics[index].closeTime =
                                (picked == null)
                                    ? controller
                                        .doctorModel.clinics[index].closeTime
                                    : CommonFunctions.timestampFromTimeOfDay(
                                        picked,
                                      );
                            controller.update();
                          },
                  );
                },
              )
            : GetBuilder<SingleClinicController>(
                builder: (controller) {
                  return SetClinicTimeContentWidget(
                    openTimeText:
                        CommonFunctions.getTime(controller.tempClinic.openTime),
                    closeTimeText: CommonFunctions.getTime(
                        controller.tempClinic.closeTime),
                    onOpenTimeButtonPressed: controller.loading
                        ? null
                        : () async {
                            TimeOfDay? picked;
                            picked = await showTimePicker(
                              context: context,
                              initialTime:
                                  CommonFunctions.timeOfDayFromTimestamp(
                                      controller.tempClinic.openTime),
                            );
                            controller.tempClinic.openTime = (picked == null)
                                ? controller.tempClinic.openTime
                                : CommonFunctions.timestampFromTimeOfDay(
                                    picked);
                            controller.update();
                          },
                    onCloseTimeButtonPressed: controller.loading
                        ? null
                        : () async {
                            TimeOfDay? picked;
                            picked = await showTimePicker(
                              context: context,
                              initialTime:
                                  CommonFunctions.timeOfDayFromTimestamp(
                                      controller.tempClinic.closeTime),
                            );
                            controller.tempClinic.closeTime = (picked == null)
                                ? controller.tempClinic.closeTime
                                : CommonFunctions.timestampFromTimeOfDay(
                                    picked);
                            controller.update();
                          },
                  );
                },
              ),
      ],
    );
  }
}
