import 'package:clinic/features/chat/controller/single_chat_page_controller.dart';
import 'package:clinic/features/medical_record/model/disease_model.dart';
import 'package:clinic/features/medical_record/model/medicine_model.dart';
import 'package:clinic/features/medical_record/model/surgery_model.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SendMedicalRecordButton extends StatelessWidget {
  const SendMedicalRecordButton({
    Key? key,
    required this.chatterId,
    required this.isBlocked,
  }) : super(key: key);
  final String chatterId;
  final bool isBlocked;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          isBlocked ? null : () => _onSendMedicalRecordButtonPressed(context),
      child: Image(
        image: AssetImage(
          isBlocked
              ? 'assets/img/medical-record-disabled.png'
              : 'assets/img/medical-record.png',
        ),
        width: 50,
        height: 50,
      ),
    );
  }

  _onSendMedicalRecordButtonPressed(BuildContext context) async {
    final SingleChatPageController controller = Get.find(tag: chatterId);
    controller.getUserMedicalRecord();
    showDialog(
      context: context,
      builder: (context) {
        return GetBuilder<SingleChatPageController>(
          tag: chatterId,
          builder: (controller) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              scrollable: true,
              title: Text(
                'إرسال السجل المرضي',
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
              content: (controller.deleteMessageLoading)
                  ? const Center(
                      child:
                          AppCircularProgressIndicator(height: 50, width: 50),
                    )
                  : (controller.medicalRecord == null)
                      ? const Text(
                          'أنت لم تقم بإنشاء السجل المرضي حتى الأن\nيمكنك إنشاء السجل المرضي من الصفحة الشخصية',
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontFamily: AppFonts.mainArabicFontFamily,
                            fontSize: 15,
                          ),
                        )
                      : Column(
                          children: [
                            (controller.medicalRecord!.diseases.isNotEmpty)
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Checkbox(
                                        activeColor: AppColors.primaryColor,
                                        value: controller
                                                .selectedDiseases.length ==
                                            controller
                                                .medicalRecord!.diseases.length,
                                        onChanged: (_) =>
                                            controller.selectAllDiseases(),
                                      ),
                                      Text(
                                        'الأمراض المزمنة',
                                        style: medicalRecordLabelTextTheme(
                                            context),
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                            (controller.medicalRecord!.diseases.isNotEmpty)
                                ? Column(
                                    children: List<ListTile>.generate(
                                      controller.medicalRecord!.diseases.length,
                                      (index) {
                                        DiseaseModel disease = controller
                                            .medicalRecord!.diseases[index];
                                        return ListTile(
                                          title: Text(
                                            disease.diseaseName,
                                            textAlign: TextAlign.right,
                                            textDirection: TextDirection.rtl,
                                            style: const TextStyle(
                                              fontFamily:
                                                  AppFonts.mainArabicFontFamily,
                                              fontSize: 13,
                                            ),
                                          ),
                                          leading: Checkbox(
                                            activeColor: AppColors.primaryColor,
                                            value: controller.selectedDiseases
                                                .contains(disease.diseaseId),
                                            onChanged: (_) =>
                                                controller.selectDisease(
                                                    disease.diseaseId),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 10,
                            ),
                            (controller.medicalRecord!.surgeries.isNotEmpty)
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Checkbox(
                                        activeColor: AppColors.primaryColor,
                                        value: controller
                                                .selectedSurgeries.length ==
                                            controller.medicalRecord!.surgeries
                                                .length,
                                        onChanged: (_) =>
                                            controller.selectAllSurgeries(),
                                      ),
                                      Text(
                                        'العمليات الجراحية',
                                        style: medicalRecordLabelTextTheme(
                                            context),
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                            (controller.medicalRecord!.surgeries.isNotEmpty)
                                ? Column(
                                    children: List<ListTile>.generate(
                                      controller
                                          .medicalRecord!.surgeries.length,
                                      (index) {
                                        SurgeryModel surgery = controller
                                            .medicalRecord!.surgeries[index];
                                        return ListTile(
                                          title: Text(
                                            surgery.surgeryName,
                                            textAlign: TextAlign.right,
                                            textDirection: TextDirection.rtl,
                                            style: const TextStyle(
                                              fontFamily:
                                                  AppFonts.mainArabicFontFamily,
                                              fontSize: 13,
                                            ),
                                          ),
                                          leading: Checkbox(
                                              activeColor:
                                                  AppColors.primaryColor,
                                              value: controller
                                                  .selectedSurgeries
                                                  .contains(surgery.surgeryId),
                                              onChanged: (_) =>
                                                  controller.selectSurgery(
                                                      surgery.surgeryId)),
                                        );
                                      },
                                    ),
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 10,
                            ),
                            (controller.medicalRecord!.medicines.isNotEmpty)
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Checkbox(
                                          activeColor: AppColors.primaryColor,
                                          value: controller
                                                  .selectedMedicines.length ==
                                              controller.medicalRecord!
                                                  .medicines.length,
                                          onChanged: (_) =>
                                              controller.selectAllMedicines()),
                                      Text(
                                        'الأدوية',
                                        style: medicalRecordLabelTextTheme(
                                            context),
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                            (controller.medicalRecord!.medicines.isNotEmpty)
                                ? Column(
                                    children: List<ListTile>.generate(
                                        controller.medicalRecord!.medicines
                                            .length, (index) {
                                      MedicineModel medicine = controller
                                          .medicalRecord!.medicines[index];
                                      return ListTile(
                                        title: Text(
                                          medicine.medicineName,
                                          textAlign: TextAlign.right,
                                          textDirection: TextDirection.rtl,
                                          style: const TextStyle(
                                            fontFamily:
                                                AppFonts.mainArabicFontFamily,
                                            fontSize: 13,
                                          ),
                                        ),
                                        leading: Checkbox(
                                          activeColor: AppColors.primaryColor,
                                          value: controller.selectedMedicines
                                              .contains(medicine.medicineId),
                                          onChanged: (_) =>
                                              controller.selectMedicine(
                                                  medicine.medicineId),
                                        ),
                                      );
                                    }),
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 10,
                            ),
                            (controller.medicalRecord!.moreInfo != null)
                                ? Align(
                                    alignment: Alignment.centerRight,
                                    child: Text('معلومات السجل الأخرى',
                                        textAlign: TextAlign.right,
                                        textDirection: TextDirection.rtl,
                                        style: medicalRecordLabelTextTheme(
                                            context)),
                                  )
                                : const SizedBox(),
                            (controller.medicalRecord!.moreInfo != null)
                                ? Align(
                                    alignment: Alignment.centerLeft,
                                    child: Switch(
                                      activeColor: AppColors.primaryColor,
                                      value: controller
                                          .includeMedicalRecordMoreInfo,
                                      onChanged: (_) => controller
                                          .updateIncludeMedicalRecordMoreInfo(),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
              actions: MyAlertDialog.getAlertDialogActions(
                _getActions(controller.medicalRecord != null &&
                    !controller.deleteMessageLoading &&
                    (controller.selectedDiseases.isNotEmpty ||
                        controller.selectedMedicines.isNotEmpty ||
                        controller.selectedSurgeries.isNotEmpty ||
                        controller.includeMedicalRecordMoreInfo)),
              ),
              actionsAlignment: MainAxisAlignment.start,
              actionsPadding: const EdgeInsets.only(left: 30, bottom: 30),
            );
          },
        );
      },
    );
  }

  _getActions(bool activeSend) {
    final SingleChatPageController controller = Get.find(tag: chatterId);

    Map<String, void Function()?> actions = {
      'العودة': () => Get.back(),
    };
    actions.addIf(activeSend, 'إرسال', () {
      controller.sendMedicalRecordMessage();
      Get.back();
    });
    return actions;
  }

  TextStyle medicalRecordLabelTextTheme(BuildContext context) => TextStyle(
        fontSize: 18,
        color:
            CommonFunctions.isLightMode(context) ? Colors.black : Colors.white,
        fontFamily: AppFonts.mainArabicFontFamily,
      );
}
