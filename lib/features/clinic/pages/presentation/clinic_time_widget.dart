import 'package:clinic/features/clinic/controller/doctor_clinics_controller.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/features/clinic/model/clinic_model.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClinicWorkTimeWidget extends StatelessWidget {
  const ClinicWorkTimeWidget({
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
      clinic = clinicModel!;
    } else {
      final controller = DoctorClinicsController.find;
      clinic = controller.clinics[clinicIndex];
    }
    return Column(
      children: [
        Text(
          'ساعات العمل',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _getClinicTimeWidget(context, clinic.openTime),
            const SizedBox(
              width: 15,
            ),
            Text(
              'من',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _getClinicTimeWidget(
              context,
              clinic.closeTime,
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              'إلى',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ],
    );
  }

  Widget _getClinicTimeWidget(BuildContext context, Timestamp time) =>
      Container(
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: (CommonFunctions.isLightMode(context))
                ? AppColors.primaryColor
                : Colors.white,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          CommonFunctions.getTime(time),
          style: TextStyle(
            fontFamily: AppFonts.mainArabicFontFamily,
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: (CommonFunctions.isLightMode(context))
                ? AppColors.primaryColor
                : Colors.white,
          ),
        ),
      );
}
