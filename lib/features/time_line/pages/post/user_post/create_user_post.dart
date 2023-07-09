import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/time_line/controller/create_user_post_controller.dart';
import 'package:clinic/features/time_line/controller/post_controller.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/data/models/user_model.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:clinic/global/widgets/circular_icon_button.dart';
import 'package:clinic/global/widgets/snackbar.dart';
import 'package:clinic/features/time_line/pages/post/user_post/disease_widget.dart';
import 'package:clinic/features/time_line/pages/post/common/user_name_and_pic_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateUserPost extends StatelessWidget {
  const CreateUserPost({super.key});
  static const String route = '/createUserPost';

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateUserPostController());

    controller.postModel.user =
        AuthenticationController.find.currentUser as UserModel;
    final List<int> numberOfdays = List.generate(30, (index) => index);
    final List<int> numberOfmonthes = List.generate(12, (index) => index);
    final List<int> numberOfyears = List.generate(100, (index) => index);
    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerRight,
          child: Text(
            'إسأل طبيب ',
            style: TextStyle(
              fontFamily: AppFonts.mainArabicFontFamily,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
        ),
        leading: TextButton(
          onPressed: () {
            if (controller.tempContent != null &&
                controller.tempContent!.trim() != '') {
              controller.postModel.content = controller.tempContent;
              controller.postModel.timeStamp = Timestamp.now();
              PostController.find.uploadUserPost(controller.postModel);
              Get.back();
              controller.onDelete();
            } else {
              MySnackBar.showSnackBar(context, 'من فضلك أدخل سؤالك');
            }
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
          ),
          child: const Text(
            'نشر',
            style: TextStyle(
              fontFamily: AppFonts.mainArabicFontFamily,
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.back();
              controller.onDelete();
            },
            icon: const Icon(
              Icons.close_rounded,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
              right: 10.0,
              left: 10.0,
              bottom: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserNameAndPicWidget(
                  userName: CommonFunctions.getFullName(
                      controller.postModel.user.firstName!,
                      controller.postModel.user.lastName!),
                  userPic: controller.postModel.user.personalImageURL,
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'ابحث عن',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: (CommonFunctions.isLightMode(context))
                          ? AppColors.primaryColor
                          : Colors.white,
                      width: 1,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: GetBuilder<CreateUserPostController>(
                        builder: (controller) {
                      return DropdownButton(
                        items: AppConstants.doctorSpecializations
                            .map(
                              (specialization) => DropdownMenuItem(
                                value: specialization,
                                child: Text(
                                  specialization,
                                  style: const TextStyle(
                                    fontFamily: AppFonts.mainArabicFontFamily,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (item) =>
                            controller.updateSearchingSpecialization(item!),
                        value: controller.postModel.searchingSpecialization,
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'هل الحالة طارئة؟',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                GetBuilder<CreateUserPostController>(builder: (controller) {
                  return Switch(
                    activeColor: Colors.red,
                    value: controller.postModel.isErgent,
                    onChanged: (value) => controller.updateErgentCase(value),
                  );
                }),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'عمر الحالة',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          'سنة',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 5,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: (CommonFunctions.isLightMode(context))
                                  ? AppColors.primaryColor
                                  : Colors.white,
                              width: 1,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: GetBuilder<CreateUserPostController>(
                                builder: (controller) {
                              return DropdownButton(
                                items: numberOfyears
                                    .map(
                                      (year) => DropdownMenuItem(
                                        value: year,
                                        child: Text(
                                          year.toString(),
                                          style: const TextStyle(
                                              fontFamily: AppFonts
                                                  .mainArabicFontFamily),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (item) {
                                  controller.updateNumberOfYears(item!);
                                },
                                value: controller.postModel.patientAge['years'],
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'شهر',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 5,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: (CommonFunctions.isLightMode(context))
                                  ? AppColors.primaryColor
                                  : Colors.white,
                              width: 1,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: GetBuilder<CreateUserPostController>(
                                builder: (controller) {
                              return DropdownButton(
                                items: numberOfmonthes
                                    .map(
                                      (month) => DropdownMenuItem(
                                        value: month,
                                        child: Text(
                                          month.toString(),
                                          style: const TextStyle(
                                              fontFamily: AppFonts
                                                  .mainArabicFontFamily),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (item) {
                                  controller.updateNumberOfMonths(item!);
                                },
                                value:
                                    controller.postModel.patientAge['months'],
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'يوم',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 5,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: (CommonFunctions.isLightMode(context))
                                  ? AppColors.primaryColor
                                  : Colors.white,
                              width: 1,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: GetBuilder<CreateUserPostController>(
                                builder: (controller) {
                              return DropdownButton(
                                items: numberOfdays
                                    .map(
                                      (day) => DropdownMenuItem(
                                        value: day,
                                        child: Text(
                                          day.toString(),
                                          style: const TextStyle(
                                              fontFamily: AppFonts
                                                  .mainArabicFontFamily),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (item) {
                                  controller.updateNumberOfDays(item!);
                                },
                                value: controller.postModel.patientAge['days'],
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'نوع الحالة',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, right: 8.0, left: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GetBuilder<CreateUserPostController>(
                          builder: (controller) {
                        return CircularIconButton(
                          onPressed: () => controller.onMalePressed(),
                          selected: controller.maleSelected,
                          child: const Icon(
                            Icons.man,
                          ),
                        );
                      }),
                      GetBuilder<CreateUserPostController>(
                          builder: (controller) {
                        return CircularIconButton(
                          onPressed: () => controller.onFemalePressed(),
                          selected: controller.femaleSelected,
                          child: const Icon(
                            Icons.woman,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'هل لدى الحالة أي أمراض مزمنة ؟',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                const SizedBox(height: 20),
                GetBuilder<CreateUserPostController>(builder: (controller) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: controller.diseases,
                    ),
                  );
                }),
                (controller.diseases.isNotEmpty)
                    ? const SizedBox(height: 10)
                    : const SizedBox(),
                Row(children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            scrollable: true,
                            title: Text(
                              'إسم المرض المزمن',
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
                            content: Center(
                              child: TextField(
                                autofocus: true,
                                textAlign: TextAlign.end,
                                maxLength: 25,
                                onChanged: (diseaseName) => controller
                                    .updateTempDiseaseName(diseaseName),
                              ),
                            ),
                            actionsAlignment: MainAxisAlignment.start,
                            actionsPadding:
                                const EdgeInsets.only(left: 30, bottom: 30),
                            actions: MyAlertDialog.getAlertDialogActions({
                              'تأكيد': () {
                                if (controller.tempDiseaseName != null &&
                                    controller.tempDiseaseName!.trim() != '' &&
                                    !controller.diseases.any((disease) =>
                                        disease.diseaseName ==
                                        controller.tempDiseaseName!.trim())) {
                                  controller.addDisease();
                                  controller.addDiseaseWidget(
                                    controller.diseases.length,
                                    DiseaseWidget(
                                        key: UniqueKey(),
                                        diseaseName:
                                            controller.tempDiseaseName!.trim(),
                                        onPressed: (diseaseName, key) =>
                                            onDiseaseButtonPressed(
                                                diseaseName, key)),
                                  );
                                  controller.tempDiseaseName = null;
                                }
                                Get.back();
                              },
                              'إلغاء': () {
                                controller.tempDiseaseName = null;
                                Get.back();
                              }
                            }),
                          );
                        },
                      );
                    },
                    child: Row(
                      children: const [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'إضافة',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: AppFonts.mainArabicFontFamily,
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        )
                      ],
                    ),
                  ),
                ]),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'إطرح سؤالك',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: (CommonFunctions.isLightMode(context))
                            ? AppColors.primaryColor
                            : Colors.white,
                      ),
                    ),
                  ),
                  maxLength: 400,
                  maxLines: 5,
                  textAlign: TextAlign.end,
                  onChanged: (content) {
                    controller.tempContent = content;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onDiseaseButtonPressed(String diseaseName, Key? key) {
    CreateUserPostController controller = Get.find();
    int index = controller.diseases.indexWhere((disease) => disease.key == key);
    controller.updateTempControllerText(diseaseName);
    Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      scrollable: true,
      title: const Text(
        'تعديل إسم المرض المزمن',
        textAlign: TextAlign.end,
        style: TextStyle(
          fontFamily: AppFonts.mainArabicFontFamily,
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
      content: Center(
        child: TextField(
          controller: controller.tempController,
          autofocus: true,
          textAlign: TextAlign.end,
          maxLength: 25,
        ),
      ),
      actionsAlignment: MainAxisAlignment.start,
      actionsPadding: const EdgeInsets.only(left: 30, bottom: 30),
      actions: MyAlertDialog.getAlertDialogActions({
        'إزالة': () {
          controller.removeDisease(diseaseName);
          controller.removeDiseaseWidget(key!);
          Get.back();
        },
        'تأكيد': () {
          if (controller.tempController.text !=
                  controller.diseases[index].diseaseName &&
              controller.tempController.text.trim() != '') {
            controller.updateDisease(
                index, controller.tempController.text.trim());
            controller.removeDiseaseWidget(key!);
            controller.addDiseaseWidget(
                index,
                DiseaseWidget(
                  key: key,
                  diseaseName: controller.tempController.text.trim(),
                  onPressed: (diseaseName, key) =>
                      onDiseaseButtonPressed(diseaseName, key),
                ));
          }
          Get.back();
        },
        'إلغاء': () => Get.back(),
      }),
    ));
  }
}
