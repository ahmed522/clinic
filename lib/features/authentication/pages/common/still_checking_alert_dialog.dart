import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StillCheckingAlertDialog extends StatelessWidget {
  const StillCheckingAlertDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      scrollable: true,
      title: const Text(
        'مراجعة البيانات...',
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontFamily: AppFonts.mainArabicFontFamily,
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
      content: const Center(
        child: Text(
          AppConstants.stillCheckingDoctorData,
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontFamily: AppFonts.mainArabicFontFamily,
            fontSize: 15,
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.start,
      actionsPadding: const EdgeInsets.only(left: 30, bottom: 30),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            AuthenticationController.find.logout(false);
            Get.back();
          },
          child: const Text(
            'حسناً',
            style: TextStyle(
              color: Colors.white,
              fontFamily: AppFonts.mainArabicFontFamily,
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }
}
