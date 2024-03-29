import 'package:clinic/features/authentication/controller/sign_in/signin_controller.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordButton extends StatelessWidget {
  const ResetPasswordButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SigninController>(builder: (controller) {
      return TextButton(
        onPressed: controller.loading
            ? null
            : () {
                MyAlertDialog.showAlertDialog(
                  context,
                  'إعادة تعيين كلمة المرور',
                  AppConstants.passwordReset,
                  MyAlertDialog.getAlertDialogActions(
                    {
                      'إلغاء': () => Get.back(),
                      'إرسال': () {
                        if (controller.tempEmail == null ||
                            !RegExp(AppConstants.emailValidationRegExp)
                                .hasMatch(controller.tempEmail!)) {
                          if (!Get.isSnackbarOpen) {
                            Get.showSnackbar(const GetSnackBar(
                              messageText: Center(
                                child: Text(
                                  'البريد الإلكتروني غير صحيح',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: AppFonts.mainArabicFontFamily,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                              backgroundColor: Colors.red,
                              snackPosition: SnackPosition.TOP,
                              snackStyle: SnackStyle.GROUNDED,
                              duration: Duration(milliseconds: 1000),
                              animationDuration: Duration(milliseconds: 500),
                            ));
                          }
                        } else {
                          controller.resetPassword(controller.tempEmail!);
                          Get.back();
                        }
                      },
                    },
                  ),
                );
              },
        style: TextButton.styleFrom(
          foregroundColor: CommonFunctions.isLightMode(context)
              ? AppColors.primaryColor
              : Colors.white,
        ),
        child: Text(
          'هل نسيت كلمة المرور؟',
          style: TextStyle(
            color: CommonFunctions.isLightMode(context)
                ? AppColors.primaryColor
                : Colors.white,
            fontFamily: AppFonts.mainArabicFontFamily,
            fontSize: 13,
          ),
        ),
      );
    });
  }
}
