import 'package:clinic/features/authentication/controller/sign_up/common/signup_controller.dart';
import 'package:clinic/features/authentication/controller/sign_up/doctor/doctor_signup_controller.dart';
import 'package:clinic/features/authentication/pages/sign_up/common/main_info_widget.dart';
import 'package:clinic/features/authentication/pages/sign_up/doctor/acadimic_info_widget.dart';
import 'package:clinic/features/authentication/pages/sign_up/doctor/doctor_signup_parent.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:get/get.dart';

class DoctorSignupPage extends StatelessWidget {
  const DoctorSignupPage({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignupController>(
        tag: DoctorSignUpParent.route,
        builder: (controller) {
          return Stack(
            children: [
              controller.loading
                  ? const LinearProgressIndicator()
                  : const SizedBox(),
              Stepper(
                currentStep: (controller as DoctorSignupController).currentStep,
                controlsBuilder:
                    (BuildContext context, ControlsDetails details) {
                  return Row(
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          disabledBackgroundColor: Colors.grey,
                          foregroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed:
                            controller.loading ? null : () => onStepCancel(),
                        child: const Text(
                          'العودة',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.primaryColor,
                            fontFamily: AppFonts.mainArabicFontFamily,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          disabledBackgroundColor: Colors.grey,
                          foregroundColor: Colors.white,
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed:
                            controller.loading ? null : () => onStepContinue(),
                        child: const Text(
                          'التالي',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontFamily: AppFonts.mainArabicFontFamily,
                          ),
                        ),
                      ),
                    ],
                  );
                },
                type: StepperType.vertical,
                steps: [
                  Step(
                    isActive: true,
                    title: Text(
                      'المعلومات الاساسية',
                      style: TextStyle(
                          fontFamily: AppFonts.mainArabicFontFamily,
                          fontWeight: FontWeight.bold,
                          color: (controller.states[0] == StepState.error)
                              ? Colors.red
                              : CommonFunctions.isLightMode(context)
                                  ? AppColors.primaryColorDark
                                  : Colors.white),
                    ),
                    content: const MainInfoWidget(),
                    state: controller.states[0],
                  ),
                  Step(
                    isActive: controller.currentStep >= 1,
                    title: Text(
                      'المعلومات الاكاديمية',
                      style: TextStyle(
                          fontFamily: AppFonts.mainArabicFontFamily,
                          fontWeight: FontWeight.bold,
                          color: (controller.states[1] == StepState.error)
                              ? Colors.red
                              : (controller.states[1] == StepState.indexed)
                                  ? Colors.grey
                                  : CommonFunctions.isLightMode(context)
                                      ? AppColors.primaryColorDark
                                      : Colors.white),
                    ),
                    content: AcadimicInfoWidget(),
                    state: controller.states[1],
                  ),
                ],
              ),
            ],
          );
        });
  }

  void onStepContinue() {
    final SignupController controller = Get.find(tag: DoctorSignUpParent.route);
    switch ((controller as DoctorSignupController).currentStep) {
      case 0:
        if ((controller).formKey.currentState!.validate() &&
            (controller).doctorModel.personalImage != null &&
            controller.ageIsValid) {
          (controller).setDoctorValidation(true);
        } else if ((controller).doctorModel.personalImage == null) {
          (controller).validatePersonalImage(false);
        }

        break;
      case 1:
        bool clinicLocationIsSet = true;
        bool clinicFormValidation = true;
        for (var clinic in controller.doctorModel.clinics) {
          if (!clinic.formKey.currentState!.validate()) {
            clinicFormValidation = false;
          }
          bool locationCoordinatesIsSet = clinic.locationLatitude != null &&
              clinic.locationLongitude != null;
          if (clinic.location == null && !locationCoordinatesIsSet) {
            clinicLocationIsSet = false;
          }
        }
        if (clinicFormValidation &&
            (controller.doctorModel.medicalIdImage != null) &&
            clinicLocationIsSet) {
          controller.setDoctorValidation(true);
        }
        break;

      default:
    }
    if ((controller).doctorValidation) {
      if ((controller).currentStep == 0) {
        (controller).incrementCurrentStep();
        (controller).updateStates(StepState.complete, StepState.editing);
      } else {
        controller.updateLoading(true);
        (controller).updateStates(StepState.complete, StepState.complete);
        for (int clinicIndex = 0;
            clinicIndex < controller.doctorModel.clinics.length;
            clinicIndex++) {
          controller.addClinicPhoneNumbers(clinicIndex);
        }
        controller.signupDoctor(controller.doctorModel).whenComplete(
              () => controller.updateLoading(false),
            );
      }
      (controller).setDoctorValidation(false);
    } else {
      StepState state0 = (controller).states[0];
      StepState state1 = (controller).states[1];
      if ((controller).currentStep == 0) {
        state0 = StepState.error;
      } else {
        state1 = StepState.error;
      }
      (controller).updateStates(state0, state1);
    }
  }

  void onStepCancel() {
    final SignupController controller = Get.find(tag: DoctorSignUpParent.route);
    if ((controller as DoctorSignupController).currentStep > 0) {
      (controller).decrementCurrentStep();
      (controller).updateStates(StepState.editing, StepState.indexed);
    }
  }
}
