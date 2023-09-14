import 'package:clinic/features/clinic/model/clinic_model.dart';
import 'package:clinic/features/clinic/pages/presentation/clinic_data_widget.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SingleClinicPreviewDialog extends StatelessWidget {
  const SingleClinicPreviewDialog({
    Key? key,
    required this.clinic,
    required this.index,
    required this.doctorId,
  }) : super(key: key);

  final ClinicModel? clinic;
  final int index;
  final String doctorId;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      scrollable: true,
      title: Text(
        'عيادة رقم ${index + 1}',
        textAlign: TextAlign.end,
        style: TextStyle(
          fontFamily: AppFonts.mainArabicFontFamily,
          fontWeight: FontWeight.w700,
          fontSize: 17,
          color: (CommonFunctions.isLightMode(context))
              ? AppColors.darkThemeBackgroundColor
              : Colors.white,
        ),
      ),
      content: ClinicDataWidget(
        clinicIndex: index,
        isDoctorPost: true,
        clinic: clinic,
        isCurrentDoctorProfile: false,
        doctorId: doctorId,
      ),
      actions: MyAlertDialog.getAlertDialogActions({
        'العودة': () => Get.back(),
      }),
      actionsAlignment: MainAxisAlignment.start,
      actionsPadding: const EdgeInsets.only(left: 30, bottom: 30),
    );
  }
}
