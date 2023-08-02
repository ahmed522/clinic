import 'package:clinic/features/clinic/controller/doctor_clinics_controller.dart';
import 'package:clinic/features/clinic/model/clinic_model.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';

class ClinicVezeetaWidget extends StatelessWidget {
  const ClinicVezeetaWidget({
    Key? key,
    required this.clinicIndex,
    this.isDoctorPost = false,
    this.clinicModel,
  }) : super(key: key);

  final int clinicIndex;
  final bool isDoctorPost;
  final ClinicModel? clinicModel;
  @override
  Widget build(BuildContext context) {
    final ClinicModel clinic;
    if (isDoctorPost) {
      if (clinicModel != null) {
        clinic = clinicModel!;
      } else {
        clinic = clinicModel!;
      }
    } else {
      final controller = DoctorClinicsController.find;
      clinic = controller.clinics[clinicIndex];
    }
    return Column(
      children: [
        Text(
          'سعر الكشف',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        Text(
          '${clinic.examineVezeeta.toString()} EGP',
          style: TextStyle(
            fontSize: 25,
            color: CommonFunctions.isLightMode(context)
                ? Colors.black
                : Colors.white,
            fontFamily: AppFonts.mainArabicFontFamily,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'سعر الإستشارة',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        Text(
          '${clinic.reexamineVezeeta.toString()} EGP',
          style: TextStyle(
            fontSize: 25,
            color: CommonFunctions.isLightMode(context)
                ? Colors.black
                : Colors.white,
            fontFamily: AppFonts.mainArabicFontFamily,
          ),
        ),
      ],
    );
  }
}
