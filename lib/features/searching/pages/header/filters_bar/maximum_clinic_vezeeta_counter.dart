import 'package:clinic/features/searching/controller/search_page_controller.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/circle_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MaximumClinicVezeetaCounter extends StatelessWidget {
  const MaximumClinicVezeetaCounter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = SearchPageController.find;
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleButton(
            onPressed: () => controller.increamentMaximumClinicVezeeta(),
            backgroundColor: (CommonFunctions.isLightMode(context))
                ? AppColors.primaryColor
                : AppColors.darkThemeBackgroundColor,
            child: const Icon(Icons.add),
          ),
          GetBuilder<SearchPageController>(
            builder: (controller) {
              return Text(
                controller.tempMaximumVezeeta.toString(),
                style: TextStyle(
                  color: (CommonFunctions.isLightMode(context))
                      ? AppColors.darkThemeBackgroundColor
                      : Colors.white,
                  fontFamily: AppFonts.mainArabicFontFamily,
                  fontSize: 16,
                ),
              );
            },
          ),
          CircleButton(
            onPressed: () => controller.decrementMaximumClinicVezeeta(),
            backgroundColor: (CommonFunctions.isLightMode(context))
                ? AppColors.primaryColor
                : AppColors.darkThemeBackgroundColor,
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
