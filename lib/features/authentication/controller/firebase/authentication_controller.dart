import 'package:clinic/features/authentication/controller/firebase/authentication_exception_handler.dart';
import 'package:clinic/features/authentication/controller/sign_in/signin_controller.dart';
import 'package:clinic/features/authentication/pages/common/email_verification_alert_dialog.dart';
import 'package:clinic/features/start/pages/start_page.dart';
import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/global/data/models/doctor_model.dart';
import 'package:clinic/global/data/models/user_model.dart';
import 'package:clinic/global/widgets/error_page.dart';
import 'package:clinic/global/widgets/snackbar.dart';
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
        .whenComplete(() => Get.dialog(
              const EmailVerificationAlertDialog(),
              barrierDismissible: false,
            ));
  }

  Future<void> createUserWithEmailAndPassword(UserModel user) async {
    try {
      loading.value = true;
      isSigning.value = true;
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: user.email!.trim(), password: user.getPassword!);
      user.userId = _firebaseAuth.currentUser!.uid;
      user.personalImageURL =
          await UserDataController.find.uploadUserPersonalImage(user);
      await UserDataController.find.createUser(user);
      await sendVerificationEmail();
      loading.value = false;
      isSigning.value = false;
      logout();
    } on FirebaseAuthException catch (e) {
      loading.value = false;
      isSigning.value = false;
      AuthenticationExceptionHandler.signupExceptionHandler(e.code);
    }
  }

  Future<void> createDoctorWithEmailAndPassword(DoctorModel doctor) async {
    try {
      loading.value = true;
      isSigning.value = true;
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: doctor.email!.trim(), password: doctor.getPassword!);
      doctor.userId = _firebaseAuth.currentUser!.uid;
      doctor.personalImageURL =
          await UserDataController.find.uploadDoctorPersonalImage(doctor);
      doctor.medicalIdImageURL =
          await UserDataController.find.uploadDoctorMedicalIdImage(doctor);
      await UserDataController.find.createDoctor(doctor);
      await sendVerificationEmail();
      loading.value = false;
      isSigning.value = false;
      logout();
    } on FirebaseAuthException catch (e) {
      AuthenticationExceptionHandler.signupExceptionHandler(e.code);
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      loading.value = true;
      isSigning.value = true;
      await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        if (!_firebaseAuth.currentUser!.emailVerified) {
          loading.value = false;
          isSigning.value = false;
          Get.dialog(const EmailVerificationAlertDialog());
        } else {
          loading.value = false;
          isSigning.value = false;
          _setInitialScreen(FirebaseAuth.instance.currentUser);
          Get.delete<SigninController>();
          MySnackBar.showGetSnackbar('تم تسجيل الدخول بنجاح', Colors.green);
        }
      });
    } on FirebaseAuthException catch (e) {
      loading.value = false;
      isSigning.value = false;
      SigninController.find.updateLoading(false);
      AuthenticationExceptionHandler.signinExceptionHandler(e.code);
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
