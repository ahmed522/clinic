import 'package:clinic/global/theme/colors/light_theme_colors.dart';
import 'package:clinic/global/theme/fonts/app_fonst.dart';
import 'package:clinic/global/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import '../widgets/stepper_widgets/step1_content.dart';
import '../widgets/stepper_widgets/step2_content.dart';

class DoctorSignupPage extends StatefulWidget {
  static const route = '/doctorSignupPage';
  const DoctorSignupPage({super.key});

  @override
  State<DoctorSignupPage> createState() => _DoctorSignupPageState();
}

class _DoctorSignupPageState extends State<DoctorSignupPage> {
  List<StepState> states = [
    StepState.editing,
    StepState.indexed,
    StepState.indexed
  ];
  int currentStep = 0;
  bool valid = false;
  static const numberOfSteps = 2;
  Step1Content step1content = Step1Content();
  Step2Content step2content = Step2Content();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: Stepper(
          currentStep: currentStep,
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            return Row(
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: LightThemeColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: onStepCancel,
                  child: const Text(
                    'العودة',
                    style: TextStyle(
                      fontSize: 18,
                      color: LightThemeColors.primaryColor,
                      fontFamily: AppFonts.mainArabicFontFamily,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: LightThemeColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: onStepContinue,
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
                    color: (states[0] == StepState.error)
                        ? Colors.red
                        : LightThemeColors.primaryColorDark),
              ),
              content: step1content,
              state: states[0],
            ),
            Step(
              isActive: currentStep >= 1,
              title: Text(
                'المعلومات الاكاديمية',
                style: TextStyle(
                    fontFamily: AppFonts.mainArabicFontFamily,
                    fontWeight: FontWeight.bold,
                    color: (states[1] == StepState.error)
                        ? Colors.red
                        : (states[1] == StepState.indexed)
                            ? Colors.grey
                            : LightThemeColors.primaryColorDark),
              ),
              content: step2content,
              state: states[1],
            ),
          ],
        ),
      ),
    );
  }

  void onStepContinue() {
    switch (currentStep) {
      case 0:
        if (step1content.formKey.currentState!.validate() &&
            step1content.imageIsSet) {
          valid = true;
        } else if (!step1content.imageIsSet) {
          step1content.validateImage!();
        }

        break;
      case 1:
        bool clinicLocationIsSet = true;
        bool clinicFormValidation = true;
        for (var clinic in step2content.clinics) {
          if (!clinic.formKey.currentState!.validate()) {
            clinicFormValidation = false;
          }
          if (!clinic.locationIsSet) {
            clinicLocationIsSet = false;
          }
        }
        if (clinicFormValidation &&
            step2content.idImageIsSet &&
            clinicLocationIsSet) {
          valid = true;
        }
        break;

      case 2:
        break;

      default:
    }
    if (valid) {
      if (currentStep < numberOfSteps - 1) {
        setState(() {
          states[currentStep] = StepState.complete;
          ++currentStep;
          states[currentStep] = StepState.editing;
        });
      } else {
        setState(() {
          states[currentStep] = StepState.complete;
        });
        MySnackBar.showSnackBar(context, 'تم التسجيل بنجاح');
      }
      valid = false;
    } else {
      setState(() {
        states[currentStep] = StepState.error;
      });
    }
  }

  void onStepCancel() {
    setState(() {
      if (currentStep > 0) {
        states[currentStep] = StepState.indexed;
        --currentStep;
        states[currentStep] = StepState.editing;
      }
    });
  }
}
