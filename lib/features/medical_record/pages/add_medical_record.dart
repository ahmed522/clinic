import 'package:clinic/features/medical_record/controller/add_medical_record_controller.dart';
import 'package:clinic/features/medical_record/model/medical_record_model.dart';
import 'package:clinic/features/medical_record/pages/add_disease_widget.dart';
import 'package:clinic/features/medical_record/pages/add_medical_record_info.dart';
import 'package:clinic/features/medical_record/pages/add_medicine_widget.dart';
import 'package:clinic/features/medical_record/pages/add_surgery_widget.dart';
import 'package:clinic/features/medical_record/pages/create_or_edit_medical_record_button.dart';
import 'package:clinic/features/time_line/pages/post/common/user_name_and_pic_widget.dart';
import 'package:clinic/global/widgets/offline_page_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddMedicalRecord extends StatelessWidget {
  const AddMedicalRecord({
    super.key,
    this.isMedicalRecordPage = false,
    this.medicalRecordModel,
  });
  final bool isMedicalRecordPage;
  final MedicalRecordModel? medicalRecordModel;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddMedicalRecordController(
        medicalRecord:
            isMedicalRecordPage ? medicalRecordModel! : MedicalRecordModel()));
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(
            isMedicalRecordPage ? 'تعديل السجل المرضي' : 'إنشاء السجل المرضي',
          ),
        ),
      ),
      body: OfflinePageBuilder(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
              right: 10.0,
              left: 10.0,
              bottom: 20.0,
            ),
            child: Column(
              children: [
                UserNameAndPicWidget(
                  userName: controller.currentUserName,
                  userPic: controller.currentUserPersonalImage,
                ),
                const SizedBox(height: 30),
                const AddDiseaseWidget(),
                const SizedBox(height: 20),
                const AddSurgeryWidget(),
                const SizedBox(height: 20),
                const AddMedicineWidget(),
                const SizedBox(height: 20),
                const AddMedicalRecordInfo(),
                const SizedBox(height: 40),
                CreateorEditMedicalRecordButton(
                  editPage: isMedicalRecordPage,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
