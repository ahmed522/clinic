import 'package:clinic/features/authentication/controller/sign_up/common/signup_controller.dart';
import 'package:clinic/features/authentication/controller/sign_up/doctor/doctor_signup_controller.dart';
import 'package:clinic/features/authentication/pages/sign_up/doctor/doctor_signup_parent.dart';
import 'package:clinic/features/clinic/controller/single_clinic_controller.dart';
import 'package:clinic/features/clinic/pages/common/day.dart';
import 'package:clinic/global/constants/clinic_page_mode.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetClinicWorkDaysWidget extends StatelessWidget {
  const SetClinicWorkDaysWidget({
    Key? key,
    required this.index,
    required this.mode,
  }) : super(key: key);

  final int index;
  final ClinicPageMode mode;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'أيام العمل',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        const SizedBox(height: 20),
        (mode == ClinicPageMode.signupMode)
            ? GetBuilder<SignupController>(
                tag: DoctorSignUpParent.route,
                builder: (controller) {
                  return (size.width > 320)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: Day.getClickableWeekDays(
                            (controller as DoctorSignupController)
                                .doctorModel
                                .clinics[index]
                                .workDays,
                            controller.loading
                                ? (day) {}
                                : (day) =>
                                    controller.updateWorkDays(day, index),
                            context,
                          ),
                        )
                      : Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: Day.getClickableWeekDays(
                                (controller as DoctorSignupController)
                                    .doctorModel
                                    .clinics[index]
                                    .workDays,
                                controller.loading
                                    ? (day) {}
                                    : (day) =>
                                        controller.updateWorkDays(day, index),
                                context,
                                daysPerRow: 3,
                                firstIndex: 4,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: Day.getClickableWeekDays(
                                controller.doctorModel.clinics[index].workDays,
                                controller.loading
                                    ? (day) {}
                                    : (day) =>
                                        controller.updateWorkDays(day, index),
                                context,
                                daysPerRow: 4,
                              ),
                            ),
                          ],
                        );
                },
              )
            : GetBuilder<SingleClinicController>(
                builder: (controller) {
                  return (size.width > 320)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: Day.getClickableWeekDays(
                            controller.tempClinic.workDays,
                            controller.loading
                                ? (day) {}
                                : (day) => controller.updateWorkDays(day),
                            context,
                          ),
                        )
                      : Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: Day.getClickableWeekDays(
                                controller.tempClinic.workDays,
                                controller.loading
                                    ? (day) {}
                                    : (day) => controller.updateWorkDays(day),
                                context,
                                daysPerRow: 3,
                                firstIndex: 4,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: Day.getClickableWeekDays(
                                controller.tempClinic.workDays,
                                controller.loading
                                    ? (day) {}
                                    : (day) => controller.updateWorkDays(day),
                                context,
                                daysPerRow: 4,
                              ),
                            ),
                          ],
                        );
                },
              ),
      ],
    );
  }
}
