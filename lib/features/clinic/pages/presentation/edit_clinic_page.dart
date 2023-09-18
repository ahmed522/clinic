import 'package:clinic/features/clinic/controller/doctor_clinics_controller.dart';
import 'package:clinic/features/clinic/controller/single_clinic_controller.dart';
import 'package:clinic/features/clinic/model/clinic_model.dart';
import 'package:clinic/features/clinic/pages/creation/create_clinic_page.dart';
import 'package:clinic/features/clinic/pages/presentation/edit_clinic_button.dart';
import 'package:clinic/global/constants/clinic_page_mode.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:clinic/global/widgets/default_appbar.dart';
import 'package:clinic/global/widgets/offline_page_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditClinicPage extends StatelessWidget {
  const EditClinicPage({
    super.key,
    required this.clinicIndex,
    required this.doctorId,
  });
  final int clinicIndex;
  final String doctorId;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ClinicModel tempClinic = ClinicModel.copy(
        DoctorClinicsController.find.clinics[clinicIndex], clinicIndex);
    Get.put(SingleClinicController(
        tempClinic: tempClinic, clinicIndex: clinicIndex));
    return Scaffold(
      appBar: const DefaultAppBar(title: 'تعديل العيادة'),
      body: OfflinePageBuilder(
        child: GetBuilder<SingleClinicController>(builder: (controller) {
          if (controller.loading) {
            return SizedBox(
              height: size.height,
              child: const Center(
                child: AppCircularProgressIndicator(height: 100, width: 100),
              ),
            );
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  CreateClinicPage(
                      index: clinicIndex, mode: ClinicPageMode.editMode),
                  const SizedBox(height: 40),
                  EditClinicButton(
                    onPressed: () => _updateClinicButtonOnPressed(context),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  _updateClinicButtonOnPressed(BuildContext context) {
    final controller = SingleClinicController.find;
    MyAlertDialog.showAlertDialog(
      context,
      'تعديل العيادة',
      'هل أنت متأكد من تعديل بيانات العيادة؟',
      MyAlertDialog.getAlertDialogActions({
        'إلغاء': () => Get.back(),
        'تأكيد': () => controller.updateClinic(doctorId),
      }),
    );
  }
}
