import 'package:clinic/features/clinic/controller/single_clinic_controller.dart';
import 'package:clinic/features/clinic/model/clinic_model.dart';
import 'package:clinic/features/clinic/pages/creation/create_clinic_page.dart';
import 'package:clinic/features/clinic/pages/presentation/add_clinic_button.dart';
import 'package:clinic/global/constants/clinic_page_mode.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:clinic/global/widgets/appbar_widget.dart';
import 'package:clinic/global/widgets/offline_page_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddClinicPage extends StatelessWidget {
  const AddClinicPage(
      {super.key, required this.clinicIndex, required this.doctorId});
  final int clinicIndex;
  final String doctorId;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ClinicModel tempClinic = ClinicModel(index: clinicIndex);
    Get.put(
      SingleClinicController(
        tempClinic: tempClinic,
        clinicIndex: clinicIndex,
        mode: ClinicPageMode.createMode,
      ),
    );
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.height / 6),
        child: const AppBarWidget(text: '        إضافة عيادة'),
      ),
      body: OfflinePageBuilder(
        child: GetBuilder<SingleClinicController>(
          builder: (controller) {
            if (controller.loading) {
              return SizedBox(
                height: 2 * size.height / 3,
                child: const Center(
                  child: AppCircularProgressIndicator(height: 100, width: 100),
                ),
              );
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    CreateClinicPage(
                        index: clinicIndex, mode: ClinicPageMode.createMode),
                    const SizedBox(height: 40),
                    AddClinicButton(
                      onPressed: () => _addClinicButtonOnPressed(context),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _addClinicButtonOnPressed(BuildContext context) {
    final controller = SingleClinicController.find;
    MyAlertDialog.showAlertDialog(
      context,
      'إضافة العيادة',
      'هل أنت متأكد من إضافة العيادة؟',
      MyAlertDialog.getAlertDialogActions(
        {
          'إلغاء': () => Get.back(),
          'تأكيد': () => controller.addClinic(doctorId),
        },
      ),
    );
  }
}
