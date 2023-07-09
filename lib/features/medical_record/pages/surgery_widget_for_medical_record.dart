import 'package:clinic/features/medical_record/controller/add_medical_record_controller.dart';
import 'package:clinic/features/medical_record/model/surgery_model.dart';
import 'package:clinic/features/medical_record/pages/medical_record_item_parent_widget.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SurgeryWidgetForMedicalRecord extends StatelessWidget {
  const SurgeryWidgetForMedicalRecord({super.key, required this.surgeryId});
  final String surgeryId;
  @override
  Widget build(BuildContext context) {
    int index;
    return GetBuilder<AddMedicalRecordController>(
      builder: (controller) {
        index = controller.medicalRecord.surgeries.indexWhere(
          (surgeryModel) => surgeryModel.surgeryId == surgeryId,
        );
        String surgeryDate = controller
            .medicalRecord.surgeries[index].surgeryDate
            .toDate()
            .toString()
            .substring(0, 10);
        return MedicalRecordItemParentWidget(
          onEditItemButtonPressed: () => onEditSurgeryButtonPressed(
            context,
            controller.medicalRecord.surgeries[index],
          ),
          onRemoveItemButtonPressed: () => onRemoveSurgeryButtonPressed(
            context,
            controller.medicalRecord.surgeries[index].surgeryId,
          ),
          itemName: controller.medicalRecord.surgeries[index].surgeryName,
          itemInfo: controller.medicalRecord.surgeries[index].info,
          surgeryDate: surgeryDate,
        );
      },
    );
  }
}

onRemoveSurgeryButtonPressed(BuildContext context, String surgeryId) {
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
              controller.loading.isTrue ? 'بالرجاء الإنتظار' : 'إزالة العملية',
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
                      'هل انت متأكد من إزالة هذه العملية؟',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
            actionsAlignment: MainAxisAlignment.start,
            actionsPadding: const EdgeInsets.only(left: 30, bottom: 30),
            actions: MyAlertDialog.getAlertDialogActions({
              'تأكيد': () {
                controller.removeSurgery(surgeryId);
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

onEditSurgeryButtonPressed(BuildContext context, SurgeryModel surgery) {
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
            'تعديل العملية الجراحية',
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
                controller: TextEditingController(text: surgery.surgeryName),
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
                child: ElevatedButton(
                  onPressed: () =>
                      editSurgeryDate(context, surgery.surgeryDate.toDate()),
                  child: const Icon(Icons.date_range_rounded),
                ),
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
                controller: TextEditingController(text: surgery.info),
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
                  surgery.surgeryName != controller.tempSurgeryName!.trim()) {
                controller.updateSurgeryName(surgery.surgeryId);
              }
              if (controller.tempSurgeryDate != null &&
                  surgery.surgeryDate != controller.surgeyDate) {
                controller.updateSurgeryDate(surgery.surgeryId);
              }
              if (controller.tempSurgeryInfo != null &&
                  surgery.info != controller.tempSurgeryInfo) {
                controller.updateSurgeryInfo(surgery.surgeryId);
              }

              controller.tempSurgeryName = null;
              controller.tempSurgeryInfo = null;
              controller.tempSurgeryDate = null;
              Get.back();
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

editSurgeryDate(BuildContext context, DateTime initialDate) async {
  final controller = AddMedicalRecordController.find;
  DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now());
  if (selectedDate != null) {
    controller.updateTempSurgeryDate(selectedDate);
  }
}
