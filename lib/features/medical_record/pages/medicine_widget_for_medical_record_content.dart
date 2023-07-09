import 'package:clinic/features/medical_record/controller/add_medical_record_controller.dart';
import 'package:clinic/features/medical_record/model/medicine_model.dart';
import 'package:clinic/features/medical_record/pages/medicine_times.dart';
import 'package:clinic/features/medical_record/pages/medicine_type.dart';
import 'package:clinic/features/time_line/pages/post/common/post_side_info.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:clinic/global/widgets/circle_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MedicineWidgetForMedicalRecordContent extends StatelessWidget {
  const MedicineWidgetForMedicalRecordContent({
    Key? key,
    required this.medicineModel,
    required this.medicineId,
    this.isMedicalRecordPage = false,
  }) : super(key: key);

  final MedicineModel medicineModel;
  final String medicineId;
  final bool isMedicalRecordPage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PostSideInfo(
              text: getMedicineTypeName(medicineModel.medicineType),
              textColor: (CommonFunctions.isLightMode(context))
                  ? AppColors.primaryColor
                  : Colors.white,
              imageAsset: getMedicineTypeImageAsset(medicineModel.medicineType),
            ),
            Text(
              medicineModel.medicineName,
              style: TextStyle(
                fontFamily: AppFonts.mainArabicFontFamily,
                color: (CommonFunctions.isLightMode(context))
                    ? Colors.black
                    : Colors.white,
                fontSize: 22,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          isMedicalRecordPage
              ? const SizedBox()
              : Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleButton(
                        icon: const Icon(Icons.edit_rounded),
                        onPressed: () =>
                            onEditMedicineButtonPressed(context, medicineModel),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CircleButton(
                        icon: const Icon(Icons.remove_rounded),
                        backgroundColor: Colors.red,
                        onPressed: () =>
                            onRemoveMedicineButtonPressed(context, medicineId),
                      ),
                    ],
                  ),
                ),
          SizedBox(
            width: isMedicalRecordPage ? 0 : 5,
          ),
          Expanded(
              flex: 8,
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  (medicineModel.info != null)
                      ? Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Text(
                            medicineModel.info!,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontFamily: AppFonts.mainArabicFontFamily,
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: (Theme.of(context).brightness ==
                                      Brightness.light)
                                  ? Colors.black87
                                  : Colors.white,
                            ),
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        medicineModel.times.toString(),
                        style: TextStyle(
                          fontFamily: AppFonts.mainArabicFontFamily,
                          color:
                              (Theme.of(context).brightness == Brightness.light)
                                  ? Colors.black
                                  : Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        'عدد المرات',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Text(
                            getPerHowMuchDays(medicineModel.perHowmuchDays),
                            style: TextStyle(
                              fontFamily: AppFonts.mainArabicFontFamily,
                              color: (Theme.of(context).brightness ==
                                      Brightness.light)
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          (medicineModel.perHowmuchDays > 2)
                              ? Text(
                                  medicineModel.perHowmuchDays.toString(),
                                  style: TextStyle(
                                    fontFamily: AppFonts.mainArabicFontFamily,
                                    color: (Theme.of(context).brightness ==
                                            Brightness.light)
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 18,
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        'كل',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                ],
              ))
        ])
      ],
    );
  }
}

onEditMedicineButtonPressed(BuildContext context, MedicineModel medicine) {
  final controller = AddMedicalRecordController.find;
  controller.tempMedicineTimes = medicine.times;
  controller.tempPerHowMuchDays = medicine.perHowmuchDays;
  controller.tempMedicineType = medicine.medicineType;
  controller.update();
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          scrollable: true,
          title: Text(
            'تعديل الدواء',
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
                  'إسم  الدواء',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              TextField(
                autofocus: true,
                textAlign: TextAlign.end,
                maxLength: 25,
                controller: TextEditingController(text: medicine.medicineName),
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
                textAlign: TextAlign.end,
                maxLength: 150,
                maxLines: 4,
                controller: TextEditingController(text: medicine.info),
                onChanged: (medicineInfo) =>
                    controller.updateTempMedicineInfo(medicineInfo),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.start,
          actionsPadding: const EdgeInsets.only(left: 30, bottom: 30),
          actions: MyAlertDialog.getAlertDialogActions({
            'تأكيد': () {
              int medicineIndex = controller.medicalRecord.medicines.indexWhere(
                  (medicineModel) =>
                      medicineModel.medicineId == medicine.medicineId);
              if (controller.tempMedicineName != null &&
                  controller.tempMedicineName!.trim() != '' &&
                  medicine.medicineName !=
                      controller.tempMedicineName!.trim()) {
                controller.updateMedicineName(medicineIndex);
              }
              if (controller.tempMedicineInfo != null &&
                  medicine.info != controller.tempMedicineInfo!.trim()) {
                controller.updateMedicineInfo(medicineIndex);
              }
              controller.updateMedicineType(medicineIndex);
              controller.updateMedicineTimes(medicineIndex);
              controller.updatePerHowMuchDays(medicineIndex);
              controller.update();
              controller.resetMedicine();
              Get.back();
            },
            'إلغاء': () {
              controller.resetMedicine();
              Get.back();
            }
          }),
        );
      });
}

onRemoveMedicineButtonPressed(BuildContext context, String medicineId) {
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
              controller.loading.isTrue ? 'بالرجاء الإنتظار' : 'إزالة الدواء',
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
                      'هل انت متأكد من إزالة هذا الدواء؟',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
            actionsAlignment: MainAxisAlignment.start,
            actionsPadding: const EdgeInsets.only(left: 30, bottom: 30),
            actions: MyAlertDialog.getAlertDialogActions({
              'تأكيد': () {
                controller.removeMedicine(medicineId);
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
