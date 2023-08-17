import 'package:clinic/features/time_line/controller/create_user_post_controller.dart';
import 'package:clinic/features/time_line/pages/post/user_post/disease_widget.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateUserPostPatientDiseasesWidget extends StatelessWidget {
  const CreateUserPostPatientDiseasesWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = CreateUserPostController.find;
    controller.screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        maxLength: 25,
                        onChanged: (diseaseName) =>
                            controller.updateTempDiseaseName(diseaseName),
                      ),
                    ),
                    actionsAlignment: MainAxisAlignment.start,
                    actionsPadding: const EdgeInsets.only(left: 30, bottom: 30),
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
                              diseaseName: controller.tempDiseaseName!.trim(),
                              onPressed: (diseaseName, key) =>
                                  _onDiseaseButtonPressed(
                                diseaseName,
                                key,
                              ),
                            ),
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
      ],
    );
  }

  void _onDiseaseButtonPressed(String diseaseName, Key? key) {
    CreateUserPostController controller = Get.find();
    int index = controller.diseases.indexWhere((disease) => disease.key == key);
    controller.updateTempControllerText(diseaseName);
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        scrollable: true,
        title: Text(
          'تعديل إسم المرض المزمن',
          textAlign: TextAlign.end,
          style: TextStyle(
            fontFamily: AppFonts.mainArabicFontFamily,
            fontWeight: FontWeight.w700,
            fontSize: (controller.screenWidth < 330) ? 17 : 20,
          ),
        ),
        content: Center(
          child: TextField(
            controller: controller.tempController,
            autofocus: true,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            maxLength: 25,
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actionsPadding: const EdgeInsets.only(left: 5, right: 5, bottom: 30),
        actions: (controller.screenWidth < 330)
            ? _getIconedActions(diseaseName, key)
            : MyAlertDialog.getAlertDialogActions({
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
                              _onDiseaseButtonPressed(diseaseName, key),
                        ));
                  }
                  Get.back();
                },
                'إلغاء': () => Get.back(),
              }),
      ),
    );
  }

  List<Widget> _getIconedActions(String diseaseName, Key? key) {
    CreateUserPostController controller = Get.find();
    int index = controller.diseases.indexWhere((disease) => disease.key == key);

    List<Widget> actions = [
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
        ),
        onPressed: () => Get.back(),
        child: const Icon(
          Icons.close_rounded,
          color: Colors.white,
          size: 20,
        ),
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
        ),
        onPressed: () {
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
                      _onDiseaseButtonPressed(diseaseName, key),
                ));
          }
          Get.back();
        },
        child: const Icon(
          Icons.check_rounded,
          color: Colors.white,
          size: 20,
        ),
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          controller.removeDisease(diseaseName);
          controller.removeDiseaseWidget(key!);
          Get.back();
        },
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Colors.white,
          size: 20,
        ),
      ),
    ];

    return actions;
  }
}
