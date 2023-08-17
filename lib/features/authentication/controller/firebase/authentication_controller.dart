import 'package:clinic/features/authentication/controller/firebase/authentication_exception_handler.dart';
import 'package:clinic/features/authentication/controller/local_storage_controller.dart';
import 'package:clinic/features/authentication/controller/sign_in/signin_controller.dart';
import 'package:clinic/features/authentication/pages/common/email_verification_alert_dialog.dart';
import 'package:clinic/features/start/pages/start_page.dart';
import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/data/models/doctor_model.dart';
import 'package:clinic/global/data/models/parent_user_model.dart';
import 'package:clinic/global/data/models/user_model.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/error_page.dart';
import 'package:clinic/global/widgets/snackbar.dart';
import 'package:clinic/features/main_page/pages/main_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthenticationController extends GetxController {
  static AuthenticationController get find => Get.find();
  final _firebaseAuth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  final userDataController = Get.put(UserDataController());
  final LocalStorageController localStorageController =
      Get.put(LocalStorageController());
  ParentUserModel? _currentUser;
  RxBool isSigning = false.obs;
  RxBool loading = true.obs;
  @override
  void onReady() async {
    try {
      await localStorageController.initLocalStorage();
      firebaseUser = Rx<User?>(_firebaseAuth.currentUser);
      firebaseUser.bindStream(_firebaseAuth.userChanges());
      ever(firebaseUser, _setInitialScreen);
    } catch (e) {
      CommonFunctions.errorHappened();
    }
  }

  _setInitialScreen(User? user) async {
    if (user != null && user.emailVerified) {
      if (loading.isFalse || isSigning.isFalse) {
        await localStorageController.getCurrentUserData();
        Get.offAll(() => const MainPage());
      }
    } else {
      if (loading.isFalse || isSigning.isFalse) {
        Get.offAll(() => const StartPage());
      }
    }
  }

  String getCurrenUserId() {
    return firebaseUser.value!.uid;
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
      user.userId = firebaseUser.value!.uid;
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
      doctor.userId = firebaseUser.value!.uid;
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
          .then((value) async {
        if (!firebaseUser.value!.emailVerified) {
          loading.value = false;
          isSigning.value = false;
          Get.dialog(const EmailVerificationAlertDialog());
        } else {
          await localStorageController.storeCurrentUserData();
          loading.value = false;
          isSigning.value = false;
          _setInitialScreen(firebaseUser.value);
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

  Future<void> logout() async {
    _currentUser = null;
    await localStorageController.removeCurrentUserData();
    await _firebaseAuth.signOut();
  }

  Future<void> restPassword(String email) async {
    try {
      _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      Get.to(() => const ErrorPage(
            imageAsset: 'assets/img/error.svg',
            message: '  حدثت مشكلة، يرجى إعادة المحاولة لاحقاً',
          ));
    }
  }

  set setCurrentUser(ParentUserModel user) => _currentUser = user;
  ParentUserModel get currentUser => _currentUser!;
  String get currentUserId => _currentUser!.userId!;
  UserType get currentUserType => _currentUser!.userType;
  String get currentUserName => CommonFunctions.getFullName(
      _currentUser!.firstName!, _currentUser!.lastName!);
  Gender get currentUserGender => _currentUser!.gender;
  Timestamp get currentUserBirthDate => _currentUser!.birthDate;
  String? get currentUserPersonalImage => _currentUser!.personalImageURL;
  String get currentDoctorSpecialization =>
      (_currentUser as DoctorModel).specialization;
}
