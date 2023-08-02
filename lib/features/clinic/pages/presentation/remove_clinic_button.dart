import 'package:clinic/features/clinic/controller/doctor_clinics_controller.dart';
import 'package:clinic/features/time_line/controller/time_line_controller.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RemoveClinicButton extends StatelessWidget {
  const RemoveClinicButton({
    Key? key,
    required this.clinicIndex,
    required this.clinicId,
  }) : super(key: key);
  final int clinicIndex;
  final String clinicId;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _onDeleteClinicButtonPressed(context),
      style: ElevatedButton.styleFrom(
          elevation: 10.0,
          padding: const EdgeInsets.all(5.0),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          side: const BorderSide(width: 0.00001)),
      child: const Text(
        'حذف العيادة',
        style: TextStyle(
          color: Colors.white,
          fontFamily: AppFonts.mainArabicFontFamily,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  _onDeleteClinicButtonPressed(BuildContext context) {
    MyAlertDialog.showAlertDialog(
        context,
        'حذف العيادة رقم ${clinicIndex + 1}',
        'هل أنت متأكد من حذف العيادة؟',
        MyAlertDialog.getAlertDialogActions({
          'إلغاء': () => Get.back(),
          'تأكيد': () async {
            await DoctorClinicsController.find.deleteClinic(clinicId);
            TimeLineController.find.loadPosts(50, true);
          }
        }));
  }
}
