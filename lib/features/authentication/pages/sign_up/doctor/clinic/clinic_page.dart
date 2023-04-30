import 'package:clinic/features/authentication/controller/sign_up/common/signup_controller.dart';
import 'package:clinic/features/authentication/controller/sign_up/doctor/doctor_signup_controller.dart';
import 'package:clinic/features/authentication/pages/sign_up/doctor/clinic/day.dart';
import 'package:clinic/features/authentication/pages/sign_up/doctor/doctor_signup_parent.dart';
import 'package:flutter/material.dart';

import 'package:clinic/global/constants/am_or_pm.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/constants/regions.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonst.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:get/get.dart';

class ClinicPage extends StatelessWidget {
  final int index;
  const ClinicPage({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final SignupController controller = Get.find(tag: DoctorSignUpParent.route);

    return Column(
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(8)),
            child: Text(
              ' عيادة رقم ${index + 1}',
              style: const TextStyle(
                fontFamily: AppFonts.mainArabicFontFamily,
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            MyAlertDialog.getInfoAlertDialog(
              context,
              'أين باقي المحافظات؟',
              AppConstants.whereIsRestGovernorates,
              {
                'أعي ذلك': () => Navigator.of(context).pop(),
              },
            ),
            Text(
              'المحافظة',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.only(
              left: 15,
              right: 5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: (Theme.of(context).brightness == Brightness.light)
                    ? AppColors.primaryColor
                    : Colors.white,
                width: 1,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: GetBuilder<SignupController>(
                  tag: DoctorSignUpParent.route,
                  builder: (controller) {
                    return DropdownButton(
                      items: Regions.governorates
                          .map(
                            (governorate) => DropdownMenuItem(
                              value: governorate,
                              child: Text(
                                governorate,
                                style: const TextStyle(
                                    fontFamily: AppFonts.mainArabicFontFamily),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (item) {
                        controller.updateClinicGovernorate(item!, index);
                      },
                      value: (controller as DoctorSignupController)
                          .doctorModel
                          .clinics[index]
                          .governorate,
                    );
                  }),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            MyAlertDialog.getInfoAlertDialog(
              context,
              'المنطقة الجغرافية',
              AppConstants.regionInfo,
              {
                'أعي ذلك': () => Navigator.of(context).pop(),
              },
            ),
            Text(
              'المنطقة',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.only(
              left: 15,
              right: 5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: (Theme.of(context).brightness == Brightness.light)
                    ? AppColors.primaryColor
                    : Colors.white,
                width: 1,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: GetBuilder<SignupController>(
                  tag: DoctorSignUpParent.route,
                  builder: (controller) {
                    return DropdownButton(
                      items: Regions.regions.keys
                          .map((region) => DropdownMenuItem(
                                value: region,
                                child: Text(
                                  region,
                                  style: const TextStyle(
                                      fontFamily:
                                          AppFonts.mainArabicFontFamily),
                                ),
                              ))
                          .toList(),
                      onChanged: (item) {
                        controller.updateClinicRegion(item!, index);
                      },
                      value: (controller as DoctorSignupController)
                          .doctorModel
                          .clinics[index]
                          .region,
                    );
                  }),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'موقع العيادة',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        Row(
          children: [
            ElevatedButton(
              style: Theme.of(context).elevatedButtonTheme.style,
              onPressed: () {
                (controller as DoctorSignupController)
                    .updateClinicLocation('location is set !!', index);
              },
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: (Theme.of(context).brightness == Brightness.light)
                        ? AppColors.darkThemeBackgroundColor
                        : Colors.white,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    'تحديد الموقع',
                    style: TextStyle(
                        color:
                            (Theme.of(context).brightness == Brightness.light)
                                ? AppColors.darkThemeBackgroundColor
                                : Colors.white,
                        fontFamily: AppFonts.mainArabicFontFamily,
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                  )
                ],
              ),
            ),
            const SizedBox(width: 10),
            GetBuilder<SignupController>(
                tag: DoctorSignUpParent.route,
                builder: (controller) {
                  if ((controller as DoctorSignupController)
                          .doctorModel
                          .clinics[index]
                          .location !=
                      null) {
                    return const Icon(Icons.done_rounded, color: Colors.green);
                  } else {
                    return const Icon(
                      Icons.close_rounded,
                      color: Colors.red,
                    );
                  }
                }),
          ],
        ),
        const SizedBox(height: 30),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'أيام العمل',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        const SizedBox(height: 15),
        GetBuilder<SignupController>(
            tag: DoctorSignUpParent.route,
            builder: (controller) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: Day.getClickableWeekDays(
                    (controller as DoctorSignupController)
                        .doctorModel
                        .clinics[index]
                        .workDays, (day) {
                  controller.updateWorkDays(day, index);
                }, context),
              );
            }),
        const SizedBox(height: 30),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'ساعات العمل',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        GetBuilder<SignupController>(
            tag: DoctorSignUpParent.route,
            builder: (controller) {
              return Row(
                children: [
                  TextButton(
                    style: Theme.of(context).elevatedButtonTheme.style,
                    onPressed: () async {
                      TimeOfDay? picked;
                      picked = await showTimePicker(
                          context: context,
                          initialTime:
                              controller.doctorModel.clinics[index].closeTime);

                      controller.doctorModel.clinics[index].closeTime =
                          (picked == null)
                              ? controller.doctorModel.clinics[index].closeTime
                              : picked;
                      controller.doctorModel.clinics[index].closeTimeFinalMin =
                          (controller.doctorModel.clinics[index].closeTime
                                      .minute <
                                  10)
                              ? (AppConstants.zero +
                                  controller.doctorModel.clinics[index]
                                      .closeTime.minute
                                      .toString())
                              : (controller
                                  .doctorModel.clinics[index].closeTime.minute
                                  .toString());
                      if (controller.doctorModel.clinics[index].closeTime.hour >
                          12) {
                        controller.doctorModel.clinics[index]
                            .closeTimeFinalHour = (controller
                                    .doctorModel.clinics[index].closeTime.hour -
                                12)
                            .toString();
                        controller.doctorModel.clinics[index].closeTimeAMOrPM =
                            AMOrPM.pm;
                      } else {
                        controller.doctorModel.clinics[index]
                            .closeTimeFinalHour = (controller.doctorModel
                                    .clinics[index].closeTime.hour ==
                                0)
                            ? '12'
                            : (controller
                                    .doctorModel.clinics[index].closeTime.hour)
                                .toString();
                        controller.doctorModel.clinics[index].closeTimeAMOrPM =
                            (controller.doctorModel.clinics[index].closeTime
                                        .hour ==
                                    12)
                                ? AMOrPM.pm
                                : AMOrPM.am;
                      }
                      controller.update();
                    },
                    child: Text(
                      '${(controller as DoctorSignupController).doctorModel.clinics[index].closeTimeFinalHour} : ${controller.doctorModel.clinics[index].closeTimeFinalMin} ${controller.doctorModel.clinics[index].closeTimeAMOrPM.name.toUpperCase()}',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'إلى',
                    style: TextStyle(
                        fontFamily: AppFonts.mainArabicFontFamily,
                        color:
                            (Theme.of(context).brightness == Brightness.light)
                                ? AppColors.darkThemeBackgroundColor
                                : Colors.white,
                        fontSize: 15),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    style: Theme.of(context).elevatedButtonTheme.style,
                    onPressed: () async {
                      TimeOfDay? picked;

                      picked = await showTimePicker(
                          context: context,
                          initialTime:
                              controller.doctorModel.clinics[index].openTime);

                      controller.doctorModel.clinics[index].openTime =
                          (picked == null)
                              ? controller.doctorModel.clinics[index].openTime
                              : picked;
                      controller.doctorModel.clinics[index].openTimeFinalMin =
                          (controller.doctorModel.clinics[index].openTime
                                      .minute <
                                  10)
                              ? (AppConstants.zero +
                                  controller.doctorModel.clinics[index].openTime
                                      .minute
                                      .toString())
                              : (controller
                                  .doctorModel.clinics[index].openTime.minute
                                  .toString());
                      if (controller.doctorModel.clinics[index].openTime.hour >
                          12) {
                        controller.doctorModel.clinics[index]
                            .openTimeFinalHour = (controller
                                    .doctorModel.clinics[index].openTime.hour -
                                12)
                            .toString();
                        controller.doctorModel.clinics[index].openTimeAMOrPM =
                            AMOrPM.pm;
                      } else {
                        controller.doctorModel.clinics[index]
                            .openTimeFinalHour = (controller
                                    .doctorModel.clinics[index].openTime.hour ==
                                0)
                            ? '12'
                            : (controller
                                    .doctorModel.clinics[index].openTime.hour)
                                .toString();
                        controller.doctorModel.clinics[index].openTimeAMOrPM =
                            (controller.doctorModel.clinics[index].openTime
                                        .hour ==
                                    12)
                                ? AMOrPM.pm
                                : AMOrPM.am;
                      }
                      controller.update();
                    },
                    child: Text(
                      '${controller.doctorModel.clinics[index].openTimeFinalHour} : ${controller.doctorModel.clinics[index].openTimeFinalMin} ${controller.doctorModel.clinics[index].openTimeAMOrPM.name.toUpperCase()}',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'من',
                    style: TextStyle(
                        fontFamily: AppFonts.mainArabicFontFamily,
                        color:
                            (Theme.of(context).brightness == Brightness.light)
                                ? Colors.grey[850]
                                : Colors.white,
                        fontSize: 15),
                  ),
                ],
              );
            }),
        const SizedBox(
          height: 30,
        ),
        Form(
          key: (controller as DoctorSignupController)
              .doctorModel
              .clinics[index]
              .formKey,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'سعر الكشف',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 130),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      validator: ((value) {
                        if (value == null || value.trim().isEmpty) {
                          controller.updateExamineVezeetaValidation(
                              false, index);
                          return 'من فضلك ادخل السعر  ';
                        } else {
                          controller.updateExamineVezeetaValidation(
                              RegExp(AppConstants.vezeetaValidationRegExp)
                                  .hasMatch(value),
                              index);
                          if (!controller.examineVezeetaValid[index]) {
                            return 'من فضلك ادخل قيمة صحيحة ';
                          }
                        }
                        controller.doctorModel.clinics[index].examineVezeeta =
                            int.parse(value);
                        return null;
                      }),
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      decoration: const InputDecoration(
                        counter: Offstage(),
                      ),
                    ),
                    GetBuilder<SignupController>(
                        tag: DoctorSignUpParent.route,
                        builder: (controller) {
                          return Container(
                            width: 20,
                            height: 5,
                            decoration: BoxDecoration(
                                color: ((controller as DoctorSignupController)
                                        .examineVezeetaValid[index])
                                    ? (Theme.of(context).brightness ==
                                            Brightness.light)
                                        ? AppColors.primaryColor
                                        : Colors.white
                                    : Colors.red,
                                borderRadius: BorderRadius.circular(10)),
                          );
                        }),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'سعر الإستشارة',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 130),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      validator: ((value) {
                        if (value == null || value.trim().isEmpty) {
                          controller.updateReexamineVezeetaValidation(
                              false, index);
                          return 'من فضلك ادخل السعر  ';
                        } else {
                          controller.updateReexamineVezeetaValidation(
                              RegExp(AppConstants.vezeetaValidationRegExp)
                                  .hasMatch(value),
                              index);
                          if (!controller.reexamineVezeetaValid[index]) {
                            return 'من فضلك ادخل قيمة صحيحة ';
                          }
                        }
                        controller.doctorModel.clinics[index].reexamineVezeeta =
                            int.parse(value);

                        return null;
                      }),
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      decoration: const InputDecoration(
                        counter: Offstage(),
                      ),
                    ),
                    GetBuilder<SignupController>(
                        tag: DoctorSignUpParent.route,
                        builder: (controller) {
                          return Container(
                            width: 20,
                            height: 5,
                            decoration: BoxDecoration(
                                color: ((controller as DoctorSignupController)
                                        .reexamineVezeetaValid[index])
                                    ? (Theme.of(context).brightness ==
                                            Brightness.light)
                                        ? AppColors.primaryColor
                                        : Colors.white
                                    : Colors.red,
                                borderRadius: BorderRadius.circular(10)),
                          );
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 40,
        )
      ],
    );
  }
}
