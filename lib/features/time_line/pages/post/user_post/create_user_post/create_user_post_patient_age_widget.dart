import 'package:clinic/features/time_line/controller/create_user_post_controller.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateUserPostPatientAgeWidget extends StatelessWidget {
  const CreateUserPostPatientAgeWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<int> numberOfdays = List.generate(30, (index) => index);
    final List<int> numberOfmonthes = List.generate(12, (index) => index);
    final List<int> numberOfyears = List.generate(100, (index) => index);
    return Column(
      children: [
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
                    child: GetBuilder<CreateUserPostController>(
                        builder: (controller) {
                      return DropdownButton(
                        borderRadius: BorderRadius.circular(15),
                        items: numberOfyears
                            .map(
                              (year) => DropdownMenuItem(
                                value: year,
                                child: Text(
                                  year.toString(),
                                  style: const TextStyle(
                                      fontFamily:
                                          AppFonts.mainArabicFontFamily),
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
                    child: GetBuilder<CreateUserPostController>(
                        builder: (controller) {
                      return DropdownButton(
                        borderRadius: BorderRadius.circular(15),
                        items: numberOfmonthes
                            .map(
                              (month) => DropdownMenuItem(
                                value: month,
                                child: Text(
                                  month.toString(),
                                  style: const TextStyle(
                                      fontFamily:
                                          AppFonts.mainArabicFontFamily),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (item) {
                          controller.updateNumberOfMonths(item!);
                        },
                        value: controller.postModel.patientAge['months'],
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
                    child: GetBuilder<CreateUserPostController>(
                        builder: (controller) {
                      return DropdownButton(
                        borderRadius: BorderRadius.circular(15),
                        items: numberOfdays
                            .map(
                              (day) => DropdownMenuItem(
                                value: day,
                                child: Text(
                                  day.toString(),
                                  style: const TextStyle(
                                      fontFamily:
                                          AppFonts.mainArabicFontFamily),
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
      ],
    );
  }
}
