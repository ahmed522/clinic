import 'package:clinic/features/authentication/controller/sign_up/common/signup_controller.dart';
import 'package:clinic/features/authentication/controller/sign_up/doctor/doctor_signup_controller.dart';
import 'package:clinic/features/authentication/pages/sign_up/doctor/doctor_signup_parent.dart';
import 'package:clinic/features/clinic/controller/single_clinic_controller.dart';
import 'package:clinic/features/clinic/pages/creation/set_clinic_vezeeta_form.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/constants/clinic_page_mode.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetClinicVezeetaWidget extends StatelessWidget {
  const SetClinicVezeetaWidget({
    Key? key,
    required this.index,
    required this.mode,
  }) : super(key: key);

  final int index;
  final ClinicPageMode mode;
  @override
  Widget build(BuildContext context) {
    if (mode == ClinicPageMode.signupMode) {
      return GetBuilder<SignupController>(
          tag: DoctorSignUpParent.route,
          builder: (controller) {
            return SetClinicVezeetaForm(
              formKey: (controller as DoctorSignupController)
                  .doctorModel
                  .clinics[index]
                  .formKey,
              examineVezeetaValidator: ((value) {
                if (value == null || value.trim().isEmpty) {
                  return 'من فضلك ادخل السعر  ';
                } else {
                  if (!RegExp(AppConstants.vezeetaValidationRegExp)
                      .hasMatch(value)) {
                    return 'من فضلك ادخل قيمة صحيحة ';
                  }
                }
                controller.doctorModel.clinics[index].examineVezeeta =
                    int.parse(value);
                return null;
              }),
              reexamineVezeetaValidator: ((value) {
                if (value == null || value.trim().isEmpty) {
                  return 'من فضلك ادخل السعر  ';
                } else {
                  if (!RegExp(AppConstants.vezeetaValidationRegExp)
                      .hasMatch(value)) {
                    return 'من فضلك ادخل قيمة صحيحة ';
                  }
                }
                controller.doctorModel.clinics[index].reexamineVezeeta =
                    int.parse(value);

                return null;
              }),
            );
          });
    } else {
      return GetBuilder<SingleClinicController>(builder: (controller) {
        return SetClinicVezeetaForm(
          formKey: controller.tempClinic.formKey,
          examineVezeetaValidator: ((value) {
            if (value == null || value.trim().isEmpty) {
              return 'من فضلك ادخل السعر  ';
            } else {
              if (!RegExp(AppConstants.vezeetaValidationRegExp)
                  .hasMatch(value)) {
                return 'من فضلك ادخل قيمة صحيحة ';
              }
            }
            controller.tempClinic.examineVezeeta = int.parse(value);
            return null;
          }),
          reexamineVezeetaValidator: ((value) {
            if (value == null || value.trim().isEmpty) {
              return 'من فضلك ادخل السعر  ';
            } else {
              if (!RegExp(AppConstants.vezeetaValidationRegExp)
                  .hasMatch(value)) {
                return 'من فضلك ادخل قيمة صحيحة ';
              }
            }
            controller.tempClinic.reexamineVezeeta = int.parse(value);
            return null;
          }),
          examineVezeeta: controller.tempClinic.examineVezeeta,
          reexamineVezeeta: controller.tempClinic.reexamineVezeeta,
        );
      });
    }
  }
}
