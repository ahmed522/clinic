import 'package:clinic/presentation/Providers/inherited_widgets/parent_user_provider.dart';
import 'package:flutter/material.dart';

import 'package:clinic/global/theme/colors/light_theme_colors.dart';
import 'package:clinic/global/theme/fonts/app_fonst.dart';
import 'package:clinic/global/widgets/snackbar.dart';
import 'package:clinic/presentation/widgets/stepper_widgets/common_stepper_widgets/main_info_widget.dart';
import 'package:clinic/presentation/widgets/stepper_widgets/doctor_stepper_widget/acadimic_info_widget.dart';

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
  MainInfoWidget mainInfoWidget = MainInfoWidget();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var doctorProvider = ParentUserProvider.of(context);

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
                  onPressed: () => onStepContinue(doctorProvider),
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
              content: mainInfoWidget,
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
              content: const AcadimicInfoWidget(),
              state: states[1],
            ),
          ],
        ),
      ),
    );
  }

  void onStepContinue(ParentUserProvider? doctorProvider) {
    switch (currentStep) {
      case 0:
        if (mainInfoWidget.formKey.currentState!.validate() &&
            doctorProvider!.doctorModel!.personalImage != null) {
          valid = true;
        } else if (doctorProvider!.doctorModel!.personalImage == null) {
          mainInfoWidget.validateImage!();
        }

        break;
      case 1:
        bool clinicLocationIsSet = true;
        bool clinicFormValidation = true;
        for (var clinic in doctorProvider!.doctorModel!.clinics) {
          if (!clinic.formKey.currentState!.validate()) {
            clinicFormValidation = false;
          }
          if (clinic.location == null) {
            clinicLocationIsSet = false;
          }
        }
        if (clinicFormValidation &&
            (doctorProvider.doctorModel!.medicalIdImage != null) &&
            clinicLocationIsSet) {
          valid = true;
        }
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
