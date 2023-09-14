import 'package:clinic/features/time_line/controller/create_doctor_post_controller.dart';
import 'package:clinic/features/time_line/model/doctor_post_type.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoctorPostTypeOptionWidget extends StatelessWidget {
  const DoctorPostTypeOptionWidget({
    Key? key,
    required this.value,
    required this.text,
    required this.iconAsset,
  }) : super(key: key);
  final DoctorPostType value;
  final String text;
  final String iconAsset;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateDoctorPostController>(
      builder: (controller) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 28,
              height: 28,
              child: Image.asset(iconAsset),
            ),
            Row(
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: CommonFunctions.isLightMode(context)
                        ? Colors.black
                        : Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Radio(
                  value: value,
                  groupValue: controller.postModel.postType,
                  onChanged: (newValue) {
                    controller.updateDoctorPostTypeGroupValue(newValue!);
                  },
                  activeColor: AppColors.primaryColor,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
