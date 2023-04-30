import 'package:clinic/features/authentication/pages/common/email_verification_alert_dialog.dart';
import 'package:clinic/features/start/pages/start_page.dart';
import 'package:clinic/features/time_line/controller/user_data_controller.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/data/models/doctor_model.dart';
import 'package:clinic/global/data/models/user_model.dart';
import 'package:clinic/global/fonts/app_fonst.dart';
import 'package:clinic/global/widgets/error_page.dart';
import 'package:clinic/global/widgets/loading.dart';
import 'package:clinic/presentation/pages/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthenticationController extends GetxController {
  static AuthenticationController get find => Get.find();
  final _firebaseAuth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  final userDataController = Get.put(UserDataController());
  RxBool isSigning = false.obs;
  RxBool loading = true.obs;
  @override
  void onReady() {
    firebaseUser = Rx<User?>(_firebaseAuth.currentUser);
    firebaseUser.bindStream(_firebaseAuth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user != null && user.emailVerified) {
      if (loading.isFalse || isSigning.isFalse) {
        Get.offAll(() => const MainPage());
      }
    } else {
      if (loading.isFalse || isSigning.isFalse) {
        Get.offAll(() => const StartPage());
      }
    }
  }

  Future sendVerificationEmail() async {
    await firebaseUser.value!
        .sendEmailVerification()
        .whenComplete(() => Get.dialog(const EmailVerificationAlertDialog()));
  }

  Future<void> createUserWithEmailAndPassword(UserModel user) async {
    try {
      loading.value = true;

      isSigning.value = true;
      Get.dialog(
        AlertDialog(
          contentPadding: const EdgeInsets.only(bottom: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          scrollable: true,
          title: const Text(
            'بالرجاء الإنتظار',
            textAlign: TextAlign.end,
            style: TextStyle(
              fontFamily: AppFonts.mainArabicFontFamily,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          content: const Loading(),
        ),
        barrierDismissible: false,
      );
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: user.email!.trim(), password: user.getPassword!);
      user.userId = _firebaseAuth.currentUser!.uid;
      sendVerificationEmail();
      user.personalImageURL =
          await UserDataController.find.uploadUserPersonalImage(user);
      await UserDataController.find.createUser(user);
      loading.value = false;
      isSigning.value = false;
      Get.showSnackbar(
        const GetSnackBar(
          messageText: Center(
            child: Text(
              'تم التسجيل بنجاح',
              style: TextStyle(
                color: Colors.white,
                fontFamily: AppFonts.mainArabicFontFamily,
                fontSize: 20,
              ),
            ),
          ),
          backgroundColor: AppColors.primaryColor,
          snackPosition: SnackPosition.TOP,
          snackStyle: SnackStyle.GROUNDED,
          duration: Duration(milliseconds: 2000),
          animationDuration: Duration(milliseconds: 500),
        ),
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'network-request-failed':
          Get.to(() => const ErrorPage(
                imageAsset: 'assets/img/error.png',
                message:
                    ' حدثت مشكلة، حاول التأكد من الإتصال بالإنترنت وإعادة المحاولة ',
              ));
          break;

        case 'email-already-in-use':
          Get.to(() => const ErrorPage(
                imageAsset: 'assets/img/login.png',
                message:
                    'هذا البريد الإلكتروني موجود بالفعل، يمكنك العودة للصفحة الرئيسية وتسجيل الدخول بإستخدامه',
              ));
          break;
        default:
          Get.to(() => const ErrorPage(
                imageAsset: 'assets/img/error.png',
                message:
                    'حدثت مشكلة، حاول التأكد من البريد الإلكتروني وإعادة المحاولة ',
              ));
      }
    }
  }

  Future<void> createDoctorWithEmailAndPassword(DoctorModel doctor) async {
    try {
      loading.value = true;

      isSigning.value = true;
      Get.dialog(
        AlertDialog(
          contentPadding: const EdgeInsets.only(bottom: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          scrollable: true,
          title: const Text(
            'بالرجاء الإنتظار',
            textAlign: TextAlign.end,
            style: TextStyle(
              fontFamily: AppFonts.mainArabicFontFamily,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          content: const Loading(),
        ),
        barrierDismissible: false,
      );
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: doctor.email!.trim(), password: doctor.getPassword!);
      doctor.userId = _firebaseAuth.currentUser!.uid;
      doctor.personalImageURL =
          await UserDataController.find.uploadDoctorPersonalImage(doctor);
      doctor.medicalIdImageURL =
          await UserDataController.find.uploadDoctorMedicalIdImage(doctor);
      await UserDataController.find.createDoctor(doctor);
      sendVerificationEmail();
      loading.value = false;
      isSigning.value = false;
      Get.showSnackbar(
        const GetSnackBar(
          messageText: Center(
            child: Text(
              'تم التسجيل بنجاح',
              style: TextStyle(
                color: Colors.white,
                fontFamily: AppFonts.mainArabicFontFamily,
                fontSize: 20,
              ),
            ),
          ),
          backgroundColor: AppColors.primaryColor,
          snackPosition: SnackPosition.TOP,
          snackStyle: SnackStyle.GROUNDED,
          duration: Duration(milliseconds: 2000),
          animationDuration: Duration(milliseconds: 500),
        ),
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'network-request-failed':
          Get.to(() => const ErrorPage(
                imageAsset: 'assets/img/error.png',
                message:
                    ' حدثت مشكلة، حاول التأكد من الإتصال بالإنترنت وإعادة المحاولة ',
              ));
          break;

        case 'email-already-in-use':
          Get.to(() => const ErrorPage(
                imageAsset: 'assets/img/login.png',
                message:
                    'هذا البريد الإلكتروني موجود بالفعل، يمكنك العودة للصفحة الرئيسية وتسجيل الدخول بإستخدامه',
              ));
          break;
        default:
          Get.to(() => const ErrorPage(
                imageAsset: 'assets/img/error.png',
                message:
                    'حدثت مشكلة، حاول التأكد من البريد الإلكتروني وإعادة المحاولة ',
              ));
      }
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        if (!_firebaseAuth.currentUser!.emailVerified) {
          Get.dialog(const EmailVerificationAlertDialog());
        } else {
          Get.showSnackbar(
            const GetSnackBar(
              messageText: Center(
                child: Text(
                  'تم تسجيل الدخول بنجاح',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: AppFonts.mainArabicFontFamily,
                    fontSize: 20,
                  ),
                ),
              ),
              backgroundColor: AppColors.primaryColor,
              snackPosition: SnackPosition.TOP,
              snackStyle: SnackStyle.GROUNDED,
              duration: Duration(milliseconds: 2000),
              animationDuration: Duration(milliseconds: 500),
            ),
          );
        }
      });
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'network-request-failed':
          Get.to(() => const ErrorPage(
                imageAsset: 'assets/img/error.png',
                message:
                    ' حدثت مشكلة، حاول التأكد من الإتصال بالإنترنت وإعادة المحاولة ',
              ));
          break;
        case 'wrong-password':
          if (!Get.isSnackbarOpen) {
            Get.showSnackbar(const GetSnackBar(
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
            ));
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
        case 'too-many-requests':
          Get.to(() => const ErrorPage(
                imageAsset: 'assets/img/error.png',
                message: '  حدثت مشكلة، يرجى إعادة المحاولة لاحقاً',
              ));
          break;
        default:
      }
    }
  }

  Future<void> logout() async => await _firebaseAuth.signOut();

  Future<void> restPassword(String email) async {
    try {
      _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      Get.to(() => const ErrorPage(
            imageAsset: 'assets/img/error.png',
            message: '  حدثت مشكلة، يرجى إعادة المحاولة لاحقاً',
          ));
    }
  }
}
