import 'dart:io';

import 'package:clinic/features/authentication/controller/sign_up/common/signup_controller.dart';
import 'package:clinic/features/authentication/controller/sign_up/doctor/doctor_signup_controller.dart';
import 'package:clinic/global/constants/clinic_page_mode.dart';
import 'package:clinic/features/clinic/model/clinic_model.dart';
import 'package:clinic/features/authentication/pages/sign_up/doctor/add_clinic_button.dart';
import 'package:clinic/features/authentication/pages/sign_up/doctor/doctor_signup_parent.dart';
import 'package:clinic/features/authentication/pages/sign_up/doctor/remove_clinic_button.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:clinic/features/clinic/pages/creation/create_clinic_page.dart';
import 'package:clinic/global/colors/app_colors.dart';

class AcadimicInfoWidget extends StatelessWidget {
  AcadimicInfoWidget({
    super.key,
  });
  final SignupController controller = Get.find(tag: DoctorSignUpParent.route);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              'assets/img/academic_data.png',
              width: 90,
            ),
          ),
          const SizedBox(height: 50),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              ' الدرجة العلمية',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              padding: const EdgeInsets.only(
                left: 15,
                right: 5,
              ),
              decoration: BoxDecoration(
                color: (CommonFunctions.isLightMode(context))
                    ? Colors.white
                    : AppColors.darkThemeBottomNavBarColor,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    spreadRadius: 0.2,
                    blurRadius: 0.7,
                    offset: Offset(0, 0.2),
                  ),
                ],
                borderRadius: BorderRadius.circular(15),
              ),
              child: DropdownButtonHideUnderline(
                child: GetBuilder<SignupController>(
                    tag: DoctorSignUpParent.route,
                    builder: (controller) {
                      return DropdownButton(
                        borderRadius: BorderRadius.circular(15),
                        items: AppConstants.doctorDegrees
                            .map(
                              (degree) => DropdownMenuItem(
                                value: degree,
                                child: Text(
                                  degree,
                                  style: const TextStyle(
                                      fontFamily:
                                          AppFonts.mainArabicFontFamily),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (item) {
                          controller.updateDoctorDegree(item!);
                        },
                        value: (controller as DoctorSignupController)
                            .doctorModel
                            .degree,
                      );
                    }),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'التخصص',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              padding: const EdgeInsets.only(
                left: 15,
                right: 5,
              ),
              decoration: BoxDecoration(
                color: (CommonFunctions.isLightMode(context))
                    ? Colors.white
                    : AppColors.darkThemeBottomNavBarColor,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    spreadRadius: 0.2,
                    blurRadius: 0.7,
                    offset: Offset(0, 0.2),
                  ),
                ],
                borderRadius: BorderRadius.circular(15),
              ),
              child: DropdownButtonHideUnderline(
                child: GetBuilder<SignupController>(
                    tag: DoctorSignUpParent.route,
                    builder: (controller) {
                      return DropdownButton(
                        borderRadius: BorderRadius.circular(15),
                        items: AppConstants.doctorSpecializations
                            .map(
                              (specialization) => DropdownMenuItem(
                                value: specialization,
                                child: Text(
                                  specialization,
                                  style: const TextStyle(
                                      fontFamily:
                                          AppFonts.mainArabicFontFamily),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (item) {
                          controller.updateDoctorSpecialization(item!);
                        },
                        value: (controller as DoctorSignupController)
                            .doctorModel
                            .specialization,
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
                'لماذا صورة بطاقة نقابة الأطباء؟',
                AppConstants.whyMedicalId,
                {
                  'أعي ذلك': () => Navigator.of(context).pop(),
                },
              ),
              Text(
                'بطاقة نقابة الأطباء',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
          Row(
            children: [
              ElevatedButton(
                style: Theme.of(context).elevatedButtonTheme.style,
                onPressed: controller.loading
                    ? null
                    : () async {
                        XFile? idImage;
                        idImage = await ImagePicker().pickImage(
                            source: ImageSource.gallery, imageQuality: 50);
                        (controller as DoctorSignupController)
                            .setDoctorMedicalIdImage(File(idImage!.path));
                      },
                child: Icon(
                  Icons.photo,
                  color: (CommonFunctions.isLightMode(context))
                      ? AppColors.darkThemeBackgroundColor
                      : Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: Theme.of(context).elevatedButtonTheme.style,
                onPressed: controller.loading
                    ? null
                    : () async {
                        XFile? idImage;
                        idImage = await ImagePicker().pickImage(
                            source: ImageSource.camera, imageQuality: 50);
                        (controller as DoctorSignupController)
                            .setDoctorMedicalIdImage(File(idImage!.path));
                      },
                child: Icon(
                  Icons.camera_alt_rounded,
                  color: (CommonFunctions.isLightMode(context))
                      ? AppColors.darkThemeBackgroundColor
                      : Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              GetBuilder<SignupController>(
                tag: DoctorSignUpParent.route,
                builder: (controller) {
                  if ((controller as DoctorSignupController)
                          .doctorModel
                          .medicalIdImage !=
                      null) {
                    return const Icon(
                      Icons.done_rounded,
                      color: Colors.green,
                    );
                  } else {
                    return const Icon(
                      Icons.close_rounded,
                      color: Colors.red,
                    );
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 30),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'العيادات',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          const SizedBox(height: 20),
          GetBuilder<SignupController>(
              tag: DoctorSignUpParent.route,
              builder: (controller) {
                return Column(
                  children: (controller as DoctorSignupController).clinics,
                );
              }),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AddClinicButton(
                onAddClinic: () {
                  (controller as DoctorSignupController)
                      .doctorModel
                      .clinics
                      .add(
                        ClinicModel(
                          index: (controller as DoctorSignupController)
                              .doctorModel
                              .clinics
                              .length,
                        ),
                      );
                  (controller as DoctorSignupController)
                      .clinicsPhoneNumbersTextControllers
                      .add(<TextEditingController>[]);
                  (controller as DoctorSignupController)
                      .clinicsLocationsValidation
                      .add(false.obs);
                  int index =
                      (controller as DoctorSignupController).clinics.length;
                  (controller as DoctorSignupController).addClinic(
                    CreateClinicPage(
                      index: index,
                      mode: ClinicPageMode.signupMode,
                    ),
                  );
                },
              ),
              const SizedBox(
                width: 5,
              ),
              GetBuilder<SignupController>(
                tag: DoctorSignUpParent.route,
                builder: (controller) {
                  if ((controller as DoctorSignupController)
                      .clinics
                      .isNotEmpty) {
                    return RemoveClinicButton(
                      onRemoveClinic: () {
                        controller.doctorModel.clinics.removeLast();
                        controller.clinicsLocationsValidation.removeLast();
                        controller.clinicsPhoneNumbersTextControllers
                            .removeLast();
                        controller.removeClinic();
                        controller.updateClinicLocationLoading(false);
                      },
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              )
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
