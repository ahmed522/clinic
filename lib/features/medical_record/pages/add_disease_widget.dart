import 'package:clinic/features/medical_record/controller/add_medical_record_controller.dart';
import 'package:clinic/features/medical_record/model/disease_model.dart';
import 'package:clinic/features/medical_record/pages/add_item_button.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class AddDiseaseWidget extends StatelessWidget {
  const AddDiseaseWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = AddMedicalRecordController.find;
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'هل تعاني من أي أمراض مزمنة ؟',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        const SizedBox(height: 20),
        GetBuilder<AddMedicalRecordController>(builder: (controller) {
          return Column(children: controller.diseases);
        }),
        (controller.medicalRecord.diseases.isNotEmpty)
            ? const SizedBox(height: 10)
            : const SizedBox(),
        Row(
          children: [
            AddItemButton(
              onAddItem: () => onAddDiseaseButton(context),
            ),
          ],
        ),
      ],
    );
  }
}

onAddDiseaseButton(BuildContext context) {
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
            'إضافة مرض مزمن',
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
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                maxLength: 25,
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
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                maxLines: 4,
                maxLength: 150,
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
                  !controller.medicalRecord.diseases.any((disease) =>
                      disease.diseaseName ==
                      controller.tempDiseaseName!.trim())) {
                DiseaseModel disease = DiseaseModel(const Uuid().v4(),
                    diseaseName: controller.tempDiseaseName!,
                    info: controller.tempDiseaseInfo);
                controller.addDisease(disease);
                Get.back();
              } else {
                controller.tempDiseaseName = null;
                controller.tempDiseaseInfo = null;
                Get.back();
              }
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
