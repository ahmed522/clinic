import 'package:clinic/features/searching/controller/search_page_controller.dart';
import 'package:clinic/features/searching/pages/header/filters_bar/maximum_clinic_vezeeta_counter.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClinicVezeetaFilterAlertDialog extends StatelessWidget {
  const ClinicVezeetaFilterAlertDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = SearchPageController.find;
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      scrollable: true,
      title: Text(
        'سعر الكشف',
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GetBuilder<SearchPageController>(
                builder: (controller) {
                  return Text(
                    '${controller.maximumVezeeta.toString()} EGP',
                    style: TextStyle(
                      fontFamily: AppFonts.mainArabicFontFamily,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: (CommonFunctions.isLightMode(context))
                          ? AppColors.darkThemeBackgroundColor
                          : Colors.white,
                    ),
                  );
                },
              ),
              Text(
                'أقل من',
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontFamily: AppFonts.mainArabicFontFamily,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: (CommonFunctions.isLightMode(context))
                      ? AppColors.darkThemeBackgroundColor
                      : Colors.white,
                ),
              ),
            ],
          ),
          const MaximumClinicVezeetaCounter()
        ],
      ),
      actionsAlignment: MainAxisAlignment.start,
      actionsPadding: const EdgeInsets.only(left: 30, bottom: 30),
      actions: MyAlertDialog.getAlertDialogActions({
        'العودة': () {
          controller.updateTempMaximumClinicVezeeta();
          Get.back();
        },
        'تأكيد': () {
          controller.addVezeetaFilter();
          Get.back();
        },
      }),
    );
  }
}
