import 'package:clinic/features/authentication/controller/sign_up/common/signup_controller.dart';
import 'package:clinic/features/authentication/controller/sign_up/doctor/doctor_signup_controller.dart';
import 'package:clinic/features/authentication/pages/sign_up/doctor/doctor_signup_parent.dart';
import 'package:clinic/features/clinic/controller/single_clinic_controller.dart';
import 'package:clinic/global/constants/clinic_page_mode.dart';
import 'package:clinic/global/widgets/card_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClinicPhoneNumberTextField extends StatelessWidget {
  const ClinicPhoneNumberTextField({
    Key? key,
    required this.mode,
    required this.clinicIndex,
    required this.index,
  }) : super(key: key);
  final ClinicPageMode mode;
  final int clinicIndex;
  final int index;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final controller = (mode == ClinicPageMode.signupMode)
        ? Get.find<SignupController>(tag: DoctorSignUpParent.route)
        : SingleClinicController.find;
    return SizedBox(
      width: size.width - 200,
      child: CardTextField(
        controller: (mode == ClinicPageMode.signupMode)
            ? (controller as DoctorSignupController)
                .clinicsPhoneNumbersTextControllers[clinicIndex][index]
            : (controller as SingleClinicController)
                .clinicsPhoneNumbersTextControllers[index],
        hintText: 'XXXX XXX XXXX',
        keyboardType: TextInputType.phone,
      ),
    );
  }
}
