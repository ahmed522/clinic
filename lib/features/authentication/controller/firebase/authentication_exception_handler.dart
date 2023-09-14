import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/widgets/error_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthenticationExceptionHandler {
  static void signupExceptionHandler(String errorCode) {
    switch (errorCode) {
      case 'network-request-failed':
        Get.to(
          () => const ErrorPage(
            imageAsset: 'assets/img/error.svg',
            message:
                'حدثت مشكلة، حاول التأكد من الإتصال بالإنترنت وإعادة المحاولة ',
          ),
        );
        break;

      case 'email-already-in-use':
        Get.to(
          () => const ErrorPage(
            imageAsset: 'assets/img/login.svg',
            message:
                'هذا البريد الإلكتروني موجود بالفعل، يمكنك العودة للصفحة الرئيسية وتسجيل الدخول بإستخدامه',
          ),
        );
        break;
      default:
        Get.to(
          () => const ErrorPage(
            imageAsset: 'assets/img/error.svg',
            message:
                'حدثت مشكلة، حاول التأكد من البريد الإلكتروني وإعادة المحاولة ',
          ),
        );
    }
  }

  static void signinExceptionHandler(String errorCode) {
    switch (errorCode) {
      case 'network-request-failed':
        Get.to(() => const ErrorPage(
              imageAsset: 'assets/img/error.svg',
              message:
                  ' حدثت مشكلة، حاول التأكد من الإتصال بالإنترنت وإعادة المحاولة ',
            ));
        break;
      case 'wrong-password':
        if (!Get.isSnackbarOpen) {
          Get.showSnackbar(
            const GetSnackBar(
              messageText: Center(
                child: Text(
                  'كلمة المرور غير صحيحة',
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
            ),
          );
        }
        break;
      case 'user-not-found':
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
        break;
      default:
        Get.to(() => const ErrorPage(
              imageAsset: 'assets/img/error.svg',
              message: '  حدثت مشكلة، يرجى إعادة المحاولة لاحقاً',
            ));
    }
  }
}
