import 'package:clinic/features/medical_record/controller/add_medical_record_controller.dart';
import 'package:clinic/features/medical_record/model/disease_model.dart';
import 'package:clinic/features/medical_record/pages/medical_record_item_parent_widget.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiseaseWidgetForMedicalRecord extends StatelessWidget {
  const DiseaseWidgetForMedicalRecord({super.key, required this.diseaseId});
  final String diseaseId;
  @override
  Widget build(BuildContext context) {
    int index;
    return GetBuilder<AddMedicalRecordController>(
      builder: (controller) {
        index = controller.medicalRecord.diseases.indexWhere(
          (diseaseModel) => diseaseModel.diseaseId == diseaseId,
        );
        return MedicalRecordItemParentWidget(
          onEditItemButtonPressed: () => onEditDiseaseButtonPressed(
            context,
            controller.medicalRecord.diseases[index],
          ),
          onRemoveItemButtonPressed: () => onRemoveDiseaseButtonPressed(
            context,
            controller.medicalRecord.diseases[index].diseaseId,
          ),
          itemName: controller.medicalRecord.diseases[index].diseaseName,
          itemInfo: controller.medicalRecord.diseases[index].info,
        );
      },
    );
  }
}

onRemoveDiseaseButtonPressed(BuildContext context, String diseaseId) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return GetX<AddMedicalRecordController>(builder: (controller) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            scrollable: true,
            title: Text(
              controller.loading.isTrue
                  ? 'بالرجاء الإنتظار'
                  : 'إزالة المرض المزمن',
              textAlign: TextAlign.end,
              style: TextStyle(
                fontFamily: AppFonts.mainArabicFontFamily,
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: (CommonFunctions.isLightMode(context))
                    ? AppColors.darkThemeBackgroundColor
                    : Colors.white,
              ),
            ),
            content: controller.loading.isTrue
                ? const Center(
                    child: AppCircularProgressIndicator(height: 50, width: 50),
                  )
                : Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'هل انت متأكد من إزالة هذا المرض المزمن؟',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
            actionsAlignment: MainAxisAlignment.start,
            actionsPadding: const EdgeInsets.only(left: 30, bottom: 30),
            actions: MyAlertDialog.getAlertDialogActions({
              'تأكيد': () {
                controller.removeDisease(diseaseId);
                Get.back();
              },
              'إلغاء': () {
                Get.back();
              }
            }),
          );
        });
      });
}

onEditDiseaseButtonPressed(BuildContext context, DiseaseModel disease) {
  final controller = AddMedicalRecordController.find;
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          scrollable: true,
          title: Text(
            'تعديل المرض المزمن',
            textAlign: TextAlign.end,
            style: TextStyle(
              fontFamily: AppFonts.mainArabicFontFamily,
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: (CommonFunctions.isLightMode(context))
                  ? AppColors.darkThemeBackgroundColor
                  : Colors.white,
            ),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'إسم المرض المزمن',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              TextField(
                autofocus: true,
                textAlign: TextAlign.end,
                maxLength: 25,
                controller: TextEditingController(text: disease.diseaseName),
                onChanged: (diseaseName) =>
                    controller.updateTempDiseaseName(diseaseName),
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'معلومات عن المرض المزمن',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              TextField(
                autofocus: true,
                textAlign: TextAlign.end,
                maxLength: 150,
                maxLines: 4,
                controller: TextEditingController(text: disease.info),
                onChanged: (diseaseInfo) =>
                    controller.updateTempDiseaseInfo(diseaseInfo),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.start,
          actionsPadding: const EdgeInsets.only(left: 30, bottom: 30),
          actions: MyAlertDialog.getAlertDialogActions({
            'تأكيد': () {
              if (controller.tempDiseaseName != null &&
                  controller.tempDiseaseName!.trim() != '' &&
                  disease.diseaseName != controller.tempDiseaseName!.trim()) {
                controller.updateDiseaseName(disease.diseaseId);
              }
              if (controller.tempDiseaseInfo != null &&
                  disease.info != controller.tempDiseaseInfo!.trim()) {
                controller.updateDiseaseInfo(disease.diseaseId);
              }
              controller.tempDiseaseName = null;
              controller.tempDiseaseInfo = null;
              Get.back();
            },
            'إلغاء': () {
              controller.tempDiseaseName = null;
              controller.tempDiseaseInfo = null;
              Get.back();
            }
          }),
        );
      });
}
