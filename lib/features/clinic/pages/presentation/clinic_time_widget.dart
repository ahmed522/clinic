import 'package:clinic/features/clinic/controller/doctor_clinics_controller.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/constants/am_or_pm.dart';
import 'package:clinic/features/clinic/model/clinic_model.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
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
          'ساعات العمل',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        const SizedBox(height: 25),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _getClinicTimeWidget(
              context,
              clinic.openTimeFinalHour,
              clinic.openTimeFinalMin,
              clinic.openTimeAMOrPM,
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              'من',
              style: TextStyle(
                color: (CommonFunctions.isLightMode(context))
                    ? AppColors.darkThemeBackgroundColor
                    : Colors.white,
                fontFamily: AppFonts.mainArabicFontFamily,
              ),
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
              clinic.closeTimeFinalHour,
              clinic.closeTimeFinalMin,
              clinic.closeTimeAMOrPM,
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              'إلى',
              style: TextStyle(
                color: (CommonFunctions.isLightMode(context))
                    ? AppColors.darkThemeBackgroundColor
                    : Colors.white,
                fontFamily: AppFonts.mainArabicFontFamily,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getClinicTimeText(
          String timeHour, String timeMinute, AMOrPM timeAmOrPm) =>
      '$timeHour : $timeMinute ${timeAmOrPm.name.toUpperCase()}';
  Widget _getClinicTimeWidget(BuildContext context, String timeHour,
          String timeMinute, AMOrPM timeAmOrPm) =>
      Container(
        padding: const EdgeInsets.all(5.0),
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
          _getClinicTimeText(timeHour, timeMinute, timeAmOrPm),
          style: TextStyle(
            fontFamily: AppFonts.mainArabicFontFamily,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: (CommonFunctions.isLightMode(context))
                ? AppColors.primaryColor
                : Colors.white,
          ),
        ),
      );
}
