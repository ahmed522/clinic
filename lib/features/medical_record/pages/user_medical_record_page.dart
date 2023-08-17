import 'package:clinic/features/chat/controller/single_chat_page_controller.dart';
import 'package:clinic/features/medical_record/controller/medical_record_page_controller.dart';
import 'package:clinic/features/medical_record/model/medical_record_model.dart';
import 'package:clinic/features/medical_record/pages/add_medical_record.dart';
import 'package:clinic/features/medical_record/pages/medical_record_item_parent_widget.dart';
import 'package:clinic/features/medical_record/pages/medicine_widget_for_medical_record.dart';
import 'package:clinic/features/time_line/pages/post/common/user_name_and_pic_widget.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/data/models/age.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/containered_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserMedicalRecordPage extends StatelessWidget {
  const UserMedicalRecordPage(
      {super.key, this.isMessage = false, this.chatterId});
  final bool isMessage;
  final String? chatterId;
  @override
  Widget build(BuildContext context) {
    final controller = isMessage
        ? SingleChatPageController.find(chatterId!)
        : MedicalRecordPageController.find;

    final size = MediaQuery.of(context).size;
    final Age userAge = isMessage
        ? (controller as SingleChatPageController).medicalRecordUserAge
        : (controller as MedicalRecordPageController).currntUserAge;
    final Gender userGender = isMessage
        ? (controller as SingleChatPageController).medicalRecordUserGender
        : (controller as MedicalRecordPageController).currentUserGender;
    final MedicalRecordModel medicalRecord = isMessage
        ? (controller as SingleChatPageController).medicalRecord!
        : (controller as MedicalRecordPageController).medicalRecord!;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            top: isMessage ? 10 : size.height / 5 - 10, left: 10, right: 10),
        child: Column(
          children: [
            UserNameAndPicWidget(
              userName: isMessage
                  ? (controller as SingleChatPageController)
                      .medicalRecordUserName
                  : (controller as MedicalRecordPageController).currentUserName,
              userPic: isMessage
                  ? (controller as SingleChatPageController)
                      .medicalRecordUserPic
                  : (controller as MedicalRecordPageController)
                      .currentUserPersonalImage,
            ),
            const SizedBox(
              height: 30,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'النوع',
                style: medicalRecordLabelTextTheme(context),
              ),
            ),
            Icon(
              (userGender == Gender.male)
                  ? Icons.male_rounded
                  : Icons.female_rounded,
              color: (userGender == Gender.male)
                  ? AppColors.primaryColor
                  : Colors.pink,
              size: 70,
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'العمر',
                style: medicalRecordLabelTextTheme(context),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      userAge.years.toString(),
                      style: medicalRecordAgeTextTheme(context),
                    ),
                    Text(
                      'سنة',
                      style: medicalRecordAgeLabelTextTheme(),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      userAge.months.toString(),
                      style: medicalRecordAgeTextTheme(context),
                    ),
                    Text(
                      'شهر',
                      style: medicalRecordAgeLabelTextTheme(),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      userAge.days.toString(),
                      style: medicalRecordAgeTextTheme(context),
                    ),
                    Text(
                      'يوم',
                      style: medicalRecordAgeLabelTextTheme(),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'الأمراض المزمنة',
                style: medicalRecordLabelTextTheme(context),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            (medicalRecord.diseases.isEmpty)
                ? Center(
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.circular(20)),
                      child: const Text(
                        'لا توجد أمراض مزمنة',
                        style: TextStyle(
                          fontFamily: AppFonts.mainArabicFontFamily,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  )
                : Column(
                    children: List<MedicalRecordItemParentWidget>.generate(
                      medicalRecord.diseases.length,
                      (index) => MedicalRecordItemParentWidget(
                        isMedicalRecordPage: true,
                        itemName: medicalRecord.diseases[index].diseaseName,
                        itemInfo: medicalRecord.diseases[index].info,
                      ),
                    ),
                  ),
            const SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'العمليات الجراحية',
                style: medicalRecordLabelTextTheme(context),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            (medicalRecord.surgeries.isEmpty)
                ? Center(
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.circular(20)),
                      child: const Text(
                        'لا توجد عمليات',
                        style: TextStyle(
                          fontFamily: AppFonts.mainArabicFontFamily,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  )
                : Column(
                    children: List<MedicalRecordItemParentWidget>.generate(
                      medicalRecord.surgeries.length,
                      (index) => MedicalRecordItemParentWidget(
                        isMedicalRecordPage: true,
                        itemName: medicalRecord.surgeries[index].surgeryName,
                        itemInfo: medicalRecord.surgeries[index].info,
                        surgeryDate: medicalRecord.surgeries[index].surgeryDate
                            .toDate()
                            .toString()
                            .substring(0, 10),
                      ),
                    ),
                  ),
            const SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'الأدوية',
                style: medicalRecordLabelTextTheme(context),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            (medicalRecord.medicines.isEmpty)
                ? Center(
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.circular(20)),
                      child: const Text(
                        'لا توجد أدوية',
                        style: TextStyle(
                          fontFamily: AppFonts.mainArabicFontFamily,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  )
                : Column(
                    children: List<MedicineWidgetForMedicalRecord>.generate(
                      medicalRecord.medicines.length,
                      (index) => MedicineWidgetForMedicalRecord(
                        isMedicalRecordPage: true,
                        medicine: medicalRecord.medicines[index],
                        medicineId: medicalRecord.medicines[index].medicineId,
                      ),
                    ),
                  ),
            const SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'معلومات أخرى',
                style: medicalRecordLabelTextTheme(context),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            (medicalRecord.moreInfo == null)
                ? const Center(
                    child: ContaineredText(text: 'لا توجد معلومات أخرى'))
                : Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: (CommonFunctions.isLightMode(context))
                            ? AppColors.primaryColor
                            : Colors.white,
                        width: .0001,
                      ),
                    ),
                    color: (CommonFunctions.isLightMode(context))
                        ? Colors.white
                        : AppColors.darkThemeBottomNavBarColor,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        medicalRecord.moreInfo!,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontFamily: AppFonts.mainArabicFontFamily,
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          color:
                              (Theme.of(context).brightness == Brightness.light)
                                  ? Colors.black87
                                  : Colors.white,
                        ),
                      ),
                    ),
                  ),
            const SizedBox(
              height: 40,
            ),
            isMessage
                ? const SizedBox()
                : ElevatedButton(
                    onPressed: () => Get.to(() => AddMedicalRecord(
                          isMedicalRecordPage: true,
                          medicalRecordModel:
                              (controller as MedicalRecordPageController)
                                  .medicalRecord,
                        )),
                    style: ElevatedButton.styleFrom(
                      elevation: 7.0,
                      padding: const EdgeInsets.all(15.0),
                      side: BorderSide(
                        width: .1,
                        color: (CommonFunctions.isLightMode(context))
                            ? AppColors.primaryColor
                            : Colors.white,
                      ),
                    ),
                    child: Text(
                      'تعديل السجل المرضي',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}

TextStyle medicalRecordLabelTextTheme(BuildContext context) => TextStyle(
      fontSize: 18,
      color: CommonFunctions.isLightMode(context) ? Colors.black : Colors.white,
      fontFamily: AppFonts.mainArabicFontFamily,
    );
TextStyle medicalRecordAgeTextTheme(BuildContext context) => TextStyle(
      fontSize: 25,
      color: CommonFunctions.isLightMode(context) ? Colors.black : Colors.white,
      fontFamily: AppFonts.mainArabicFontFamily,
    );
TextStyle medicalRecordAgeLabelTextTheme() => const TextStyle(
      fontSize: 20,
      color: AppColors.primaryColor,
      fontFamily: AppFonts.mainArabicFontFamily,
    );
