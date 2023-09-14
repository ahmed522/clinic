import 'package:clinic/features/time_line/controller/create_user_post_controller.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateUserPostSearchingSpecializationWidget extends StatelessWidget {
  const CreateUserPostSearchingSpecializationWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              },
            ),
          ),
        ),
      ],
    );
  }
}
