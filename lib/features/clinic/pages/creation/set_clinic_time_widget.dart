import 'package:clinic/features/authentication/controller/sign_up/common/signup_controller.dart';
import 'package:clinic/features/authentication/controller/sign_up/doctor/doctor_signup_controller.dart';
import 'package:clinic/features/authentication/pages/sign_up/doctor/doctor_signup_parent.dart';
import 'package:clinic/features/clinic/controller/single_clinic_controller.dart';
import 'package:clinic/features/clinic/pages/creation/set_clinic_time_content_widget.dart';
import 'package:clinic/global/constants/am_or_pm.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/constants/clinic_page_mode.dart';
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
                    openTimeText:
                        '${(controller as DoctorSignupController).doctorModel.clinics[index].openTimeFinalHour} : ${controller.doctorModel.clinics[index].openTimeFinalMin} ${controller.doctorModel.clinics[index].openTimeAMOrPM.name.toUpperCase()}',
                    closeTimeText:
                        '${controller.doctorModel.clinics[index].closeTimeFinalHour} : ${controller.doctorModel.clinics[index].closeTimeFinalMin} ${controller.doctorModel.clinics[index].closeTimeAMOrPM.name.toUpperCase()}',
                    onOpenTimeButtonPressed: controller.loading
                        ? null
                        : () async {
                            TimeOfDay? picked;

                            picked = await showTimePicker(
                              context: context,
                              initialTime: controller
                                  .doctorModel.clinics[index].openTime,
                            );

                            controller.doctorModel.clinics[index].openTime =
                                (picked == null)
                                    ? controller
                                        .doctorModel.clinics[index].openTime
                                    : picked;
                            controller.doctorModel.clinics[index]
                                .openTimeFinalMin = (controller.doctorModel
                                        .clinics[index].openTime.minute <
                                    10)
                                ? (AppConstants.zero +
                                    controller.doctorModel.clinics[index]
                                        .openTime.minute
                                        .toString())
                                : (controller
                                    .doctorModel.clinics[index].openTime.minute
                                    .toString());
                            if (controller
                                    .doctorModel.clinics[index].openTime.hour >
                                12) {
                              controller.doctorModel.clinics[index]
                                  .openTimeFinalHour = (controller.doctorModel
                                          .clinics[index].openTime.hour -
                                      12)
                                  .toString();
                              controller.doctorModel.clinics[index]
                                  .openTimeAMOrPM = AMOrPM.pm;
                            } else {
                              controller.doctorModel.clinics[index]
                                  .openTimeFinalHour = (controller.doctorModel
                                          .clinics[index].openTime.hour ==
                                      0)
                                  ? '12'
                                  : (controller.doctorModel.clinics[index]
                                          .openTime.hour)
                                      .toString();
                              controller.doctorModel.clinics[index]
                                  .openTimeAMOrPM = (controller.doctorModel
                                          .clinics[index].openTime.hour ==
                                      12)
                                  ? AMOrPM.pm
                                  : AMOrPM.am;
                            }
                            controller.update();
                          },
                    onCloseTimeButtonPressed: controller.loading
                        ? null
                        : () async {
                            TimeOfDay? picked;
                            picked = await showTimePicker(
                                context: context,
                                initialTime: controller
                                    .doctorModel.clinics[index].closeTime);

                            controller.doctorModel.clinics[index].closeTime =
                                (picked == null)
                                    ? controller
                                        .doctorModel.clinics[index].closeTime
                                    : picked;
                            controller.doctorModel.clinics[index]
                                .closeTimeFinalMin = (controller.doctorModel
                                        .clinics[index].closeTime.minute <
                                    10)
                                ? (AppConstants.zero +
                                    controller.doctorModel.clinics[index]
                                        .closeTime.minute
                                        .toString())
                                : (controller
                                    .doctorModel.clinics[index].closeTime.minute
                                    .toString());
                            if (controller
                                    .doctorModel.clinics[index].closeTime.hour >
                                12) {
                              controller.doctorModel.clinics[index]
                                  .closeTimeFinalHour = (controller.doctorModel
                                          .clinics[index].closeTime.hour -
                                      12)
                                  .toString();
                              controller.doctorModel.clinics[index]
                                  .closeTimeAMOrPM = AMOrPM.pm;
                            } else {
                              controller.doctorModel.clinics[index]
                                  .closeTimeFinalHour = (controller.doctorModel
                                          .clinics[index].closeTime.hour ==
                                      0)
                                  ? '12'
                                  : (controller.doctorModel.clinics[index]
                                          .closeTime.hour)
                                      .toString();
                              controller.doctorModel.clinics[index]
                                  .closeTimeAMOrPM = (controller.doctorModel
                                          .clinics[index].closeTime.hour ==
                                      12)
                                  ? AMOrPM.pm
                                  : AMOrPM.am;
                            }
                            controller.update();
                          },
                  );
                },
              )
            : GetBuilder<SingleClinicController>(
                builder: (controller) {
                  return SetClinicTimeContentWidget(
                    openTimeText:
                        '${controller.tempClinic.openTimeFinalHour} : ${controller.tempClinic.openTimeFinalMin} ${controller.tempClinic.openTimeAMOrPM.name.toUpperCase()}',
                    closeTimeText:
                        '${controller.tempClinic.closeTimeFinalHour} : ${controller.tempClinic.closeTimeFinalMin} ${controller.tempClinic.closeTimeAMOrPM.name.toUpperCase()}',
                    onOpenTimeButtonPressed: controller.loading
                        ? null
                        : () async {
                            TimeOfDay? picked;
                            picked = await showTimePicker(
                              context: context,
                              initialTime: controller.tempClinic.openTime,
                            );
                            if (picked != null) {
                              controller.tempClinic.openTime = picked;
                            }

                            controller.tempClinic.openTimeFinalMin =
                                (controller.tempClinic.openTime.minute < 10)
                                    ? (AppConstants.zero +
                                        controller.tempClinic.openTime.minute
                                            .toString())
                                    : (controller.tempClinic.openTime.minute
                                        .toString());
                            if (controller.tempClinic.openTime.hour > 12) {
                              controller.tempClinic.openTimeFinalHour =
                                  (controller.tempClinic.openTime.hour - 12)
                                      .toString();
                              controller.tempClinic.openTimeAMOrPM = AMOrPM.pm;
                            } else {
                              controller.tempClinic.openTimeFinalHour =
                                  (controller.tempClinic.openTime.hour == 0)
                                      ? '12'
                                      : (controller.tempClinic.openTime.hour)
                                          .toString();
                              controller.tempClinic.openTimeAMOrPM =
                                  (controller.tempClinic.openTime.hour == 12)
                                      ? AMOrPM.pm
                                      : AMOrPM.am;
                            }
                            controller.update();
                          },
                    onCloseTimeButtonPressed: controller.loading
                        ? null
                        : () async {
                            TimeOfDay? picked;
                            picked = await showTimePicker(
                              context: context,
                              initialTime: controller.tempClinic.closeTime,
                            );
                            if (picked != null) {
                              controller.tempClinic.closeTime = picked;
                            }

                            controller.tempClinic.closeTimeFinalMin =
                                (controller.tempClinic.closeTime.minute < 10)
                                    ? (AppConstants.zero +
                                        controller.tempClinic.closeTime.minute
                                            .toString())
                                    : (controller.tempClinic.closeTime.minute
                                        .toString());
                            if (controller.tempClinic.closeTime.hour > 12) {
                              controller.tempClinic.closeTimeFinalHour =
                                  (controller.tempClinic.closeTime.hour - 12)
                                      .toString();
                              controller.tempClinic.closeTimeAMOrPM = AMOrPM.pm;
                            } else {
                              controller.tempClinic.closeTimeFinalHour =
                                  (controller.tempClinic.closeTime.hour == 0)
                                      ? '12'
                                      : (controller.tempClinic.closeTime.hour)
                                          .toString();
                              controller.tempClinic.closeTimeAMOrPM =
                                  (controller.tempClinic.closeTime.hour == 12)
                                      ? AMOrPM.pm
                                      : AMOrPM.am;
                            }
                            controller.update();
                          },
                  );
                },
              ),
      ],
    );
  }
}
