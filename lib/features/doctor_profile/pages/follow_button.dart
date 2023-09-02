import 'package:clinic/features/doctor_profile/controller/doctor_profile_page_controller.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FollowButton extends StatelessWidget {
  const FollowButton({
    Key? key,
    required this.doctorId,
  }) : super(key: key);
  final String doctorId;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DoctorProfilePageController>(
      tag: doctorId,
      builder: (controller) {
        return ElevatedButton(
          onPressed: controller.followLoading
              ? () {}
              : () => controller.onFollowDoctorButtonPressed(),
          style: ElevatedButton.styleFrom(
            backgroundColor: controller.followed
                ? AppColors.primaryColor
                : CommonFunctions.isLightMode(context)
                    ? Colors.white
                    : AppColors.darkThemeBackgroundColor,
            foregroundColor: controller.followed
                ? Colors.white
                : CommonFunctions.isLightMode(context)
                    ? AppColors.primaryColor
                    : Colors.white,
            elevation: 5.0,
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 8.0),
            side: BorderSide(
              width: 1.2,
              color: controller.followed
                  ? AppColors.primaryColor
                  : (CommonFunctions.isLightMode(context))
                      ? AppColors.primaryColor
                      : Colors.white,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: controller.followLoading
              ? const AppCircularProgressIndicator(width: 30, height: 30)
              : controller.followed
                  ? const Text(
                      'إلغاء المتابعة',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: AppFonts.mainArabicFontFamily,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : Text(
                      'متابعة',
                      style: TextStyle(
                        color: (CommonFunctions.isLightMode(context))
                            ? AppColors.primaryColor
                            : Colors.white,
                        fontFamily: AppFonts.mainArabicFontFamily,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
        );
      },
    );
  }
}
