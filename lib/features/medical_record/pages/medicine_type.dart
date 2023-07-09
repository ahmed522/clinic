import 'package:clinic/features/medical_record/controller/add_medical_record_controller.dart';
import 'package:clinic/features/medical_record/model/medicine.dart';
import 'package:clinic/features/medical_record/pages/single_disease_type.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';

class MedicineType extends StatelessWidget {
  const MedicineType({super.key, required this.selectedType});
  final Medicine selectedType;
  @override
  Widget build(BuildContext context) {
    final controller = AddMedicalRecordController.find;
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SingleDiseaseType(
                imageAsset: 'assets/img/syringe.png',
                diseaseName: 'حقن',
                backgroundColor: (selectedType == Medicine.syringe)
                    ? AppColors.primaryColor
                    : (CommonFunctions.isLightMode(context))
                        ? Colors.white
                        : AppColors.darkThemeBackgroundColor,
                onTap: () =>
                    controller.updateTempMedicineType(Medicine.syringe),
              ),
              SingleDiseaseType(
                imageAsset: 'assets/img/syrup.png',
                diseaseName: 'شراب',
                backgroundColor: (selectedType == Medicine.syrup)
                    ? AppColors.primaryColor
                    : (CommonFunctions.isLightMode(context))
                        ? Colors.white
                        : AppColors.darkThemeBackgroundColor,
                onTap: () => controller.updateTempMedicineType(Medicine.syrup),
              ),
              SingleDiseaseType(
                imageAsset: 'assets/img/pills.png',
                diseaseName: 'حبوب',
                backgroundColor: (selectedType == Medicine.pills)
                    ? AppColors.primaryColor
                    : (CommonFunctions.isLightMode(context))
                        ? Colors.white
                        : AppColors.darkThemeBackgroundColor,
                onTap: () => controller.updateTempMedicineType(Medicine.pills),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SingleDiseaseType(
                imageAsset: 'assets/img/mouth-rinse.png',
                diseaseName: 'مضمضة للفم',
                backgroundColor: (selectedType == Medicine.mouthRinse)
                    ? AppColors.primaryColor
                    : (CommonFunctions.isLightMode(context))
                        ? Colors.white
                        : AppColors.darkThemeBackgroundColor,
                onTap: () =>
                    controller.updateTempMedicineType(Medicine.mouthRinse),
              ),
              SingleDiseaseType(
                imageAsset: 'assets/img/suppository.png',
                diseaseName: 'لبوس',
                backgroundColor: (selectedType == Medicine.suppository)
                    ? AppColors.primaryColor
                    : (CommonFunctions.isLightMode(context))
                        ? Colors.white
                        : AppColors.darkThemeBackgroundColor,
                onTap: () =>
                    controller.updateTempMedicineType(Medicine.suppository),
              ),
              SingleDiseaseType(
                imageAsset: 'assets/img/nasal-spray.png',
                diseaseName: 'بخاخ للأنف',
                backgroundColor: (selectedType == Medicine.nasalSpray)
                    ? AppColors.primaryColor
                    : (CommonFunctions.isLightMode(context))
                        ? Colors.white
                        : AppColors.darkThemeBackgroundColor,
                onTap: () =>
                    controller.updateTempMedicineType(Medicine.nasalSpray),
              ),
              SingleDiseaseType(
                imageAsset: 'assets/img/cream.png',
                diseaseName: 'دهان',
                backgroundColor: (selectedType == Medicine.cream)
                    ? AppColors.primaryColor
                    : (CommonFunctions.isLightMode(context))
                        ? Colors.white
                        : AppColors.darkThemeBackgroundColor,
                onTap: () => controller.updateTempMedicineType(Medicine.cream),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
