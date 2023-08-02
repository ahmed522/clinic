import 'package:clinic/features/medical_record/controller/add_medical_record_controller.dart';
import 'package:clinic/features/medical_record/model/medicine_model.dart';
import 'package:clinic/features/medical_record/pages/medicine_widget_for_medical_record_content.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MedicineWidgetForMedicalRecord extends StatelessWidget {
  const MedicineWidgetForMedicalRecord({
    super.key,
    required this.medicineId,
    this.isMedicalRecordPage = false,
    this.medicine,
  });
  final MedicineModel? medicine;
  final String medicineId;
  final bool isMedicalRecordPage;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Card(
        elevation: 3,
        shadowColor: AppColors.primaryColorLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: BorderSide(
            color: (CommonFunctions.isLightMode(context))
                ? AppColors.primaryColor
                : Colors.white,
            width: .5,
          ),
        ),
        color: (CommonFunctions.isLightMode(context))
            ? Colors.white
            : AppColors.darkThemeBottomNavBarColor,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: isMedicalRecordPage
              ? MedicineWidgetForMedicalRecordContent(
                  isMedicalRecordPage: true,
                  medicineModel: medicine!,
                  medicineId: medicineId)
              : GetBuilder<AddMedicalRecordController>(
                  builder: (controller) {
                    int index = controller.medicalRecord.medicines.indexWhere(
                      (medicineModel) => medicineModel.medicineId == medicineId,
                    );
                    MedicineModel medicineModel =
                        controller.medicalRecord.medicines[index];
                    return MedicineWidgetForMedicalRecordContent(
                        medicineModel: medicineModel, medicineId: medicineId);
                  },
                ),
        ),
      ),
    );
  }
}
