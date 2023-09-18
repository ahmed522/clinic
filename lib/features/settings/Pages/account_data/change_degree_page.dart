import 'package:clinic/features/settings/Pages/account_data/top_widget.dart';
import 'package:clinic/features/settings/controller/change_degree_page_controller.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:clinic/global/widgets/default_appbar.dart';
import 'package:clinic/global/widgets/offline_page_builder.dart';
import 'package:clinic/global/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeDegreePage extends StatelessWidget {
  const ChangeDegreePage({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangeDegreePageController());
    return Scaffold(
      appBar: const DefaultAppBar(
        title: 'تغيير الدرجة العلمية',
      ),
      body: OfflinePageBuilder(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 10.0,
              top: 60.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TopWidget(icon: Icons.school_rounded),
                const SizedBox(
                  height: 60,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'الدرجة العلمية',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 5,
                    ),
                    decoration: BoxDecoration(
                      color: (CommonFunctions.isLightMode(context))
                          ? Colors.white
                          : AppColors.darkThemeBottomNavBarColor,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          spreadRadius: 0.2,
                          blurRadius: 0.7,
                          offset: Offset(0, 0.2),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: GetBuilder<ChangeDegreePageController>(
                        builder: (controller) {
                          return DropdownButton(
                            borderRadius: BorderRadius.circular(15),
                            icon: const Icon(Icons.arrow_drop_down_rounded),
                            items: AppConstants.doctorDegrees
                                .map(
                                  (degree) => DropdownMenuItem(
                                    value: degree,
                                    child: Text(
                                      degree,
                                      style: const TextStyle(
                                        fontFamily:
                                            AppFonts.mainArabicFontFamily,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (item) {
                              controller.updateDegree(item!);
                            },
                            value: controller.degree,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () => controller.onPreviewPostPressed(),
                      icon: const Icon(
                        Icons.preview_rounded,
                        size: 20,
                      ),
                    ),
                    Text(
                      'إضافة منشور',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
                GetBuilder<ChangeDegreePageController>(
                  builder: (controller) {
                    return Switch(
                      value: controller.uploadPost,
                      onChanged: (value) => controller.updateUploadPost(value),
                      activeColor: AppColors.primaryColor,
                    );
                  },
                ),
                const SizedBox(height: 70),
                GetBuilder<ChangeDegreePageController>(
                  builder: (controller) {
                    return Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: controller.loading
                            ? null
                            : () => _onChangeDegreeButtonPressed(context),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                        child: controller.loading
                            ? const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: AppCircularProgressIndicator(
                                  width: 40,
                                  height: 40,
                                ),
                              )
                            : const Text(
                                'تغيير الدرجة العلمية ',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: AppFonts.mainArabicFontFamily,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onChangeDegreeButtonPressed(BuildContext context) {
    final controller = ChangeDegreePageController.find;
    if (controller.degree == controller.currentDoctorDegree) {
      if (!Get.isSnackbarOpen) {
        MySnackBar.showGetSnackbar(
          'لم تقم بتغيير درجتك العلمية',
          AppColors.primaryColor,
          isTop: false,
          duration: const Duration(milliseconds: 1000),
        );
      }
    } else {
      MyAlertDialog.showAlertDialog(
        context,
        'تغيير الدرجة العلمية',
        'هل انت متأكد من تغيير الدرجة العلمية؟',
        MyAlertDialog.getAlertDialogActions(
          {
            'العودة': () => Get.back(),
            'تغيير': () {
              controller.changeDegree();
              Get.back();
            },
          },
        ),
      );
    }
  }
}
