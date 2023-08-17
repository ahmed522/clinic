import 'package:clinic/features/medical_record/controller/add_medical_record_controller.dart';
import 'package:clinic/features/medical_record/model/medicine_model.dart';
import 'package:clinic/features/medical_record/pages/add_item_button.dart';
import 'package:clinic/features/medical_record/pages/medicine_times.dart';
import 'package:clinic/features/medical_record/pages/medicine_type.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class AddMedicineWidget extends StatelessWidget {
  const AddMedicineWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = AddMedicalRecordController.find;
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text('الأدوية', style: Theme.of(context).textTheme.bodyText1),
        ),
        const SizedBox(height: 20),
        GetBuilder<AddMedicalRecordController>(builder: (controller) {
          return Column(children: controller.medicines);
        }),
        (controller.medicalRecord.medicines.isNotEmpty)
            ? const SizedBox(height: 10)
            : const SizedBox(),
        Row(
          children: [
            AddItemButton(
              onAddItem: () => onAddMedicineButton(context),
            ),
          ],
        ),
      ],
    );
  }
}

onAddMedicineButton(BuildContext context) {
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
            'إضافة دواء',
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
                  'إسم الدواء',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              TextField(
                autofocus: true,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                maxLength: 25,
                onChanged: (medicineName) =>
                    controller.updateTempMedicineName(medicineName),
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'نوع الدواء',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              GetBuilder<AddMedicalRecordController>(builder: (controller) {
                return MedicineType(selectedType: controller.tempMedicineType);
              }),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'عدد المرات',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              GetBuilder<AddMedicalRecordController>(builder: (controller) {
                return MedicineTimes(
                  times: controller.tempMedicineTimes,
                  onIncreament: () => controller.icreamentTempMedicineTimes(),
                  onDecreament: () => controller.decreamentTempMedicineTimes(),
                );
              }),
              const SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'تكرار الدواء كل كم يوم؟',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              GetBuilder<AddMedicalRecordController>(builder: (controller) {
                return MedicineTimes(
                  times: controller.tempPerHowMuchDays,
                  onIncreament: () => controller.icreamentTempPerHowMuchDays(),
                  onDecreament: () => controller.decreamentTempPerHowMuchDays(),
                );
              }),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'معلومات عن الدواء',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              TextField(
                autofocus: true,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                maxLines: 4,
                maxLength: 150,
                onChanged: (medicineInfo) =>
                    controller.updateTempMedicineInfo(medicineInfo),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.start,
          actionsPadding: const EdgeInsets.only(left: 30, bottom: 30),
          actions: MyAlertDialog.getAlertDialogActions({
            'تأكيد': () {
              if (controller.tempMedicineName != null &&
                  controller.tempMedicineName!.trim() != '' &&
                  !controller.medicalRecord.medicines.any((medicine) =>
                      medicine.medicineName ==
                      controller.tempMedicineName!.trim())) {
                MedicineModel medicine = MedicineModel(
                  const Uuid().v4(),
                  medicineType: controller.tempMedicineType,
                  medicineName: controller.tempMedicineName!,
                  times: controller.tempMedicineTimes,
                  perHowmuchDays: controller.tempPerHowMuchDays,
                  info: controller.tempMedicineInfo,
                );
                controller.addMedicine(medicine);
                Get.back();
              } else {
                controller.resetMedicine();
                Get.back();
              }
            },
            'إلغاء': () {
              controller.resetMedicine();
              Get.back();
            }
          }),
        );
      });
}
