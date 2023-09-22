import 'package:clinic/features/searching/controller/search_page_controller.dart';
import 'package:clinic/features/searching/pages/header/top_bar/search_option_item.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CurrentSearchOptionWidget extends StatelessWidget {
  const CurrentSearchOptionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            spreadRadius: 0.3,
            blurRadius: 0.8,
            offset: Offset(0, 0.3),
          ),
        ],
        color: (CommonFunctions.isLightMode(context))
            ? Colors.white
            : AppColors.darkThemeBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: GetBuilder<SearchPageController>(
        builder: (controller) {
          return SearchOptionItem(
            option: controller.currentOption,
            textStyle: const TextStyle(fontSize: 17),
          );
        },
      ),
    );
  }
}
