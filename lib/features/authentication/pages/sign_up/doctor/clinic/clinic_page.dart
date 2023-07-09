import 'package:clinic/features/authentication/controller/sign_up/common/signup_controller.dart';
import 'package:clinic/features/authentication/controller/sign_up/doctor/doctor_signup_controller.dart';
import 'package:clinic/features/authentication/pages/sign_up/doctor/clinic/day.dart';
import 'package:clinic/features/authentication/pages/sign_up/doctor/doctor_signup_parent.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';

import 'package:clinic/global/constants/am_or_pm.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/constants/regions.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

class ClinicPage extends StatelessWidget {
  final int index;
  const ClinicPage({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final SignupController controller = Get.find(tag: DoctorSignUpParent.route);
    final size = MediaQuery.of(context).size;

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
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              padding: const EdgeInsets.only(
                left: 15,
                right: 5,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: (CommonFunctions.isLightMode(context))
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
                                      fontFamily:
                                          AppFonts.mainArabicFontFamily),
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
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              padding: const EdgeInsets.only(
                left: 15,
                right: 5,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: (CommonFunctions.isLightMode(context))
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
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GetX<SignupController>(
                tag: DoctorSignUpParent.route,
                builder: (controller) {
                  if ((controller as DoctorSignupController)
                      .locationValidation
                      .isTrue) {
                    return const Icon(Icons.done_rounded, color: Colors.green);
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
        Padding(
          padding: const EdgeInsets.only(right: 80.0),
          child: TextField(
            decoration: InputDecoration(
              icon: const Icon(
                Icons.location_on_outlined,
              ),
              helperText: 'ادخل عنوان العيادة بالتفصيل',
              helperStyle: TextStyle(
                  color: (CommonFunctions.isLightMode(context))
                      ? AppColors.darkThemeBackgroundColor
                      : Colors.white,
                  fontFamily: AppFonts.mainArabicFontFamily,
                  fontWeight: FontWeight.w500,
                  fontSize: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onChanged: (value) => (controller as DoctorSignupController)
                .updateClinicLocationFromTextField(value, index),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ElevatedButton(
                style: Theme.of(context).elevatedButtonTheme.style,
                onPressed: ((controller as DoctorSignupController)
                            .clinicLocationLoading ||
                        controller.loading)
                    ? null
                    : () => getCurrentLocation(),
                child: GetBuilder<SignupController>(
                    tag: DoctorSignUpParent.route,
                    builder: (controller) {
                      return Row(
                        children: [
                          (controller as DoctorSignupController)
                                  .clinicLocationLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: (Theme.of(context).brightness ==
                                            Brightness.light)
                                        ? AppColors.primaryColor
                                        : Colors.white,
                                  ),
                                )
                              : Icon(
                                  Icons.location_on_outlined,
                                  color: (CommonFunctions.isLightMode(context))
                                      ? AppColors.darkThemeBackgroundColor
                                      : Colors.white,
                                  size: 20,
                                ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            'إستخدم الموقع الحالي',
                            style: TextStyle(
                                color: (CommonFunctions.isLightMode(context))
                                    ? AppColors.darkThemeBackgroundColor
                                    : Colors.white,
                                fontFamily: AppFonts.mainArabicFontFamily,
                                fontWeight: FontWeight.w500,
                                fontSize: 15),
                          )
                        ],
                      );
                    }),
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
                    fontSize: 14),
              ),
            ],
          ),
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
              return (size.width > 320)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: Day.getClickableWeekDays(
                          (controller as DoctorSignupController)
                              .doctorModel
                              .clinics[index]
                              .workDays, (day) {
                        controller.updateWorkDays(day, index);
                      }, context),
                    )
                  : Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: Day.getClickableWeekDays(
                              (controller as DoctorSignupController)
                                  .doctorModel
                                  .clinics[index]
                                  .workDays, (day) {
                            controller.updateWorkDays(day, index);
                          }, context, daysPerRow: 3, firstIndex: 4),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: Day.getClickableWeekDays(
                              controller.doctorModel.clinics[index].workDays,
                              (day) {
                            controller.updateWorkDays(day, index);
                          }, context, daysPerRow: 4),
                        ),
                      ],
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
              return Column(
                children: [
                  Row(
                    children: [
                      TextButton(
                        style: Theme.of(context).elevatedButtonTheme.style,
                        onPressed: controller.loading
                            ? null
                            : () async {
                                TimeOfDay? picked;

                                picked = await showTimePicker(
                                    context: context,
                                    initialTime:
                                        (controller as DoctorSignupController)
                                            .doctorModel
                                            .clinics[index]
                                            .openTime);

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
                                    : (controller.doctorModel.clinics[index]
                                        .openTime.minute
                                        .toString());
                                if (controller.doctorModel.clinics[index]
                                        .openTime.hour >
                                    12) {
                                  controller.doctorModel.clinics[index]
                                      .openTimeFinalHour = (controller
                                              .doctorModel
                                              .clinics[index]
                                              .openTime
                                              .hour -
                                          12)
                                      .toString();
                                  controller.doctorModel.clinics[index]
                                      .openTimeAMOrPM = AMOrPM.pm;
                                } else {
                                  controller.doctorModel.clinics[index]
                                      .openTimeFinalHour = (controller
                                              .doctorModel
                                              .clinics[index]
                                              .openTime
                                              .hour ==
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
                        child: Text(
                          '${(controller as DoctorSignupController).doctorModel.clinics[index].openTimeFinalHour} : ${controller.doctorModel.clinics[index].openTimeFinalMin} ${controller.doctorModel.clinics[index].openTimeAMOrPM.name.toUpperCase()}',
                          style: TextStyle(
                            color: (Theme.of(context).brightness ==
                                    Brightness.light)
                                ? AppColors.primaryColor
                                : Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'من',
                        style: TextStyle(
                            fontFamily: AppFonts.mainArabicFontFamily,
                            color: (Theme.of(context).brightness ==
                                    Brightness.light)
                                ? Colors.grey[850]
                                : Colors.white,
                            fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      TextButton(
                        style: Theme.of(context).elevatedButtonTheme.style,
                        onPressed: controller.loading
                            ? null
                            : () async {
                                TimeOfDay? picked;
                                picked = await showTimePicker(
                                    context: context,
                                    initialTime: controller
                                        .doctorModel.clinics[index].closeTime);

                                controller
                                        .doctorModel.clinics[index].closeTime =
                                    (picked == null)
                                        ? controller.doctorModel.clinics[index]
                                            .closeTime
                                        : picked;
                                controller.doctorModel.clinics[index]
                                    .closeTimeFinalMin = (controller.doctorModel
                                            .clinics[index].closeTime.minute <
                                        10)
                                    ? (AppConstants.zero +
                                        controller.doctorModel.clinics[index]
                                            .closeTime.minute
                                            .toString())
                                    : (controller.doctorModel.clinics[index]
                                        .closeTime.minute
                                        .toString());
                                if (controller.doctorModel.clinics[index]
                                        .closeTime.hour >
                                    12) {
                                  controller.doctorModel.clinics[index]
                                      .closeTimeFinalHour = (controller
                                              .doctorModel
                                              .clinics[index]
                                              .closeTime
                                              .hour -
                                          12)
                                      .toString();
                                  controller.doctorModel.clinics[index]
                                      .closeTimeAMOrPM = AMOrPM.pm;
                                } else {
                                  controller.doctorModel.clinics[index]
                                      .closeTimeFinalHour = (controller
                                              .doctorModel
                                              .clinics[index]
                                              .closeTime
                                              .hour ==
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
                        child: Text(
                          '${controller.doctorModel.clinics[index].closeTimeFinalHour} : ${controller.doctorModel.clinics[index].closeTimeFinalMin} ${controller.doctorModel.clinics[index].closeTimeAMOrPM.name.toUpperCase()}',
                          style: TextStyle(
                            color: (Theme.of(context).brightness ==
                                    Brightness.light)
                                ? AppColors.primaryColor
                                : Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'إلى',
                        style: TextStyle(
                            fontFamily: AppFonts.mainArabicFontFamily,
                            color: (Theme.of(context).brightness ==
                                    Brightness.light)
                                ? AppColors.darkThemeBackgroundColor
                                : Colors.white,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ],
              );
            }),
        const SizedBox(
          height: 30,
        ),
        Form(
          key: controller.doctorModel.clinics[index].formKey,
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

  getCurrentLocation() async {
    final SignupController controller =
        Get.find<SignupController>(tag: DoctorSignUpParent.route);
    (controller as DoctorSignupController).updateClinicLocationLoading(true);
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionIsGiven;
    LocationData locationData;
    permissionIsGiven = await location.hasPermission();
    if (permissionIsGiven == PermissionStatus.denied) {
      permissionIsGiven = await location.requestPermission();
      if (permissionIsGiven == PermissionStatus.denied) {
        controller.updateClinicLocationLoading(false);

        return;
      }
    }
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        controller.updateClinicLocationLoading(false);
        return;
      }
    }
    locationData = await location.getLocation();
    controller.latitude = locationData.latitude;
    controller.longitude = locationData.longitude;
    controller.updateClinicLocationFromCurrentLocation(index);
  }
}
