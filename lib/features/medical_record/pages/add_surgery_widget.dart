import 'package:clinic/features/medical_record/controller/add_medical_record_controller.dart';
import 'package:clinic/features/medical_record/model/surgery_model.dart';
import 'package:clinic/features/medical_record/pages/add_item_button.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:clinic/global/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class AddSurgeryWidget extends StatelessWidget {
  const AddSurgeryWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = AddMedicalRecordController.find;
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text('هل قمت بأي عمليات جراحية مسبقاً؟',
              style: Theme.of(context).textTheme.bodyText1),
        ),
        const SizedBox(height: 20),
        GetBuilder<AddMedicalRecordController>(builder: (controller) {
          return Column(children: controller.surgeries);
        }),
        (controller.medicalRecord.surgeries.isNotEmpty)
            ? const SizedBox(height: 10)
            : const SizedBox(),
        Row(
          children: [
            AddItemButton(
              onAddItem: () => onAddSurgeryButton(context),
            ),
          ],
        ),
      ],
    );
  }
}

onAddSurgeryButton(BuildContext context) {
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
            'إضافة عملية جراحية',
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
                  'إسم العملية',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              TextField(
                autofocus: true,
                textAlign: TextAlign.end,
                maxLength: 25,
                onChanged: (surgeryName) =>
                    controller.updateTempSurgeryName(surgeryName),
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'تاريخ العملية',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: GetBuilder<AddMedicalRecordController>(
                    builder: (controller) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () => addSurgeryDate(context),
                        child: const Icon(Icons.date_range_rounded),
                      ),
                      const SizedBox(width: 10.0),
                      (controller.tempSurgeryDate != null)
                          ? const Icon(Icons.done_rounded, color: Colors.green)
                          : const Icon(
                              Icons.close_rounded,
                              color: Colors.red,
                            )
                    ],
                  );
                }),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'معلومات عن العملية',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              TextField(
                autofocus: true,
                textAlign: TextAlign.end,
                maxLines: 4,
                maxLength: 150,
                onChanged: (surgeryInfo) =>
                    controller.updateTempSurgeryInfo(surgeryInfo),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.start,
          actionsPadding: const EdgeInsets.only(left: 30, bottom: 30),
          actions: MyAlertDialog.getAlertDialogActions({
            'تأكيد': () {
              if (controller.tempSurgeryName != null &&
                  controller.tempSurgeryName!.trim() != '' &&
                  !controller.medicalRecord.surgeries.any((surgery) =>
                      surgery.surgeryName ==
                      controller.tempSurgeryName!.trim())) {
                if (controller.tempSurgeryDate == null) {
                  controller.tempSurgeryInfo = null;
                  controller.tempSurgeryName = null;
                  Get.back();
                  MySnackBar.showSnackBar(
                      context, 'من فضلك أدخل تاريخ العملية');
                } else {
                  SurgeryModel surgery = SurgeryModel(
                    const Uuid().v4(),
                    surgeryName: controller.tempSurgeryName!,
                    surgeryDate: controller.surgeyDate,
                    info: controller.tempSurgeryInfo,
                  );
                  controller.addSurgery(surgery);
                  Get.back();
                }
              } else {
                controller.tempSurgeryInfo = null;
                controller.tempSurgeryDate = null;
                Get.back();
              }
            },
            'إلغاء': () {
              controller.tempSurgeryName = null;
              controller.tempSurgeryDate = null;
              controller.tempSurgeryInfo = null;
              Get.back();
            }
          }),
        );
      });
}

addSurgeryDate(BuildContext context) async {
  final controller = AddMedicalRecordController.find;
  DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: (controller.tempSurgeryDate == null)
          ? DateTime.now()
          : controller.tempSurgeryDate!,
      firstDate: DateTime(1950),
      lastDate: DateTime.now());
  if (selectedDate != null) {
    controller.updateTempSurgeryDate(selectedDate);
  }
}
