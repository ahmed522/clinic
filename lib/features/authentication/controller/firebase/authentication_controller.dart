import 'dart:math';

import 'package:clinic/features/authentication/controller/firebase/authentication_exception_handler.dart';
import 'package:clinic/features/authentication/controller/local_storage_controller.dart';
import 'package:clinic/features/authentication/controller/sign_in/signin_controller.dart';
import 'package:clinic/features/authentication/pages/common/email_verification_alert_dialog.dart';
import 'package:clinic/features/authentication/pages/common/still_checking_alert_dialog.dart';
import 'package:clinic/features/notifications/controller/notifications_controller.dart';
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
  late final Rx<User?> _firebaseUser;
  final _userDataController = Get.put(UserDataController());
  late final NotificationsController _notificationController;
  final LocalStorageController _localStorageController =
      Get.put(LocalStorageController());

  ParentUserModel? _currentUser;
  RxBool isSigning = false.obs;
  RxBool loading = true.obs;
  Future<bool> get mustUpdate => FirebaseFirestore.instance
      .collection('administrations')
      .doc('admin')
      .get()
      .then((value) => value['must_update']);
  Future<bool> get serverError => FirebaseFirestore.instance
      .collection('administrations')
      .doc('admin')
      .get()
      .then((value) => value['server_error']);
  Future<bool> isDoctorChecked(String uid) => FirebaseFirestore.instance
      .collection('doctors')
      .doc(uid)
      .get()
      .then<bool>((snapshot) => snapshot['checked']);
  late UserType? firebaseUserType;
  @override
  void onReady() async {
    try {
      await _localStorageController.initLocalStorage();
      _firebaseUser = Rx<User?>(_firebaseAuth.currentUser);
      _firebaseUser.bindStream(_firebaseAuth.userChanges());
      _notificationController = Get.put(NotificationsController());
      _notificationController.initNotifications();
      ever(_firebaseUser, _setInitialScreen);
    } catch (e) {
      CommonFunctions.errorHappened();
    }
  }

  _setInitialScreen(User? user) async {
    if (await mustUpdate) {
      Get.offAll(
          () => const ErrorPage(
                imageAsset: 'assets/img/update.svg',
                message: 'يجب عليك تحديث تطبيق طبيب لمتابعة الإستخدام',
              ),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 500));
    } else if (await serverError) {
      Get.offAll(
          () => const ErrorPage(
                imageAsset: 'assets/img/error.svg',
                message:
                    'حدثت مشكلة نعمل على حلها الان، يرجى إعادة المحاولة لاحقاً',
              ),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 500));
    } else {
      if (user != null) {
        bool doctorCheck = false;
        if (Get.isRegistered<UserDataController>()) {
          firebaseUserType =
              await _userDataController.getUserTypeById(firebaseUserId);
          doctorCheck = (((firebaseUserType == UserType.doctor) &&
                  (await isDoctorChecked(firebaseUserId))) ||
              (firebaseUserType != UserType.doctor));
        }
        if (user.emailVerified && doctorCheck) {
          if (loading.isFalse || isSigning.isFalse) {
            await _localStorageController.getCurrentUserData();
            Get.offAll(() => const MainPage(),
                transition: Transition.fadeIn,
                duration: const Duration(milliseconds: 500));
          }
        } else {
          if (isSigning.isFalse) {
            logout(false);
          }
        }
      } else {
        if (loading.isFalse || isSigning.isFalse) {
          Get.offAll(() => const StartPage(),
              transition: Transition.fadeIn,
              duration: const Duration(milliseconds: 300));
        }
      }
    }
  }

  String get firebaseUserId => _firebaseUser.value!.uid;

  Future sendVerificationEmail() async {
    await _firebaseUser.value!.sendEmailVerification().then(
          (_) => MySnackBar.showGetSnackbar(
            'تم إرسال رسالة التحقق إلى بريدك الإلكتروني',
            Colors.green,
          ),
        );
  }

  Future<void> createUserWithEmailAndPassword(UserModel user) async {
    try {
      loading.value = true;
      isSigning.value = true;
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: user.email!.trim(), password: user.getPassword!);
      user.userId = _firebaseUser.value!.uid;
      user.personalImageURL =
          await _userDataController.uploadUserPersonalImage(user);
      await _userDataController.createUser(user);
      await sendVerificationEmail();
      loading.value = false;
      isSigning.value = false;
      logout(false);
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
      doctor.userId = _firebaseUser.value!.uid;
      doctor.personalImageURL =
          await _userDataController.uploadDoctorPersonalImage(doctor);
      doctor.medicalIdImageURL =
          await _userDataController.uploadDoctorMedicalIdImage(doctor);
      await _userDataController.createDoctor(doctor);
      await sendVerificationEmail();
      loading.value = false;
      isSigning.value = false;
      logout(false);
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
          .then(
        (value) async {
          bool doctorCheck = false;
          if (Get.isRegistered<UserDataController>()) {
            firebaseUserType =
                await _userDataController.getUserTypeById(firebaseUserId);
            doctorCheck = (firebaseUserType == UserType.doctor) &&
                !await isDoctorChecked(firebaseUserId);
          }

          if (!_firebaseUser.value!.emailVerified) {
            loading.value = false;
            Get.dialog(
              WillPopScope(
                  onWillPop: () async => false,
                  child: const EmailVerificationAlertDialog()),
              barrierDismissible: false,
            );
          } else if (doctorCheck) {
            loading.value = false;
            Get.dialog(
              WillPopScope(
                onWillPop: () async => false,
                child: const StillCheckingAlertDialog(),
              ),
              barrierDismissible: false,
            );
          } else {
            await _localStorageController.storeCurrentUserData();
            await _userDataController.addNewUserToken(
              currentUserId,
              currentUserType,
              _notificationController.currentToken!,
              currentUserType == UserType.doctor
                  ? currentDoctorSpecialization
                  : null,
            );
            loading.value = false;
            isSigning.value = false;
            _setInitialScreen(_firebaseUser.value);
            Get.delete<SigninController>();
            MySnackBar.showGetSnackbar('تم تسجيل الدخول بنجاح', Colors.green);
          }
        },
      );
    } on FirebaseAuthException catch (e) {
      loading.value = false;
      isSigning.value = false;
      SigninController.find.updateLoading(false);
      AuthenticationExceptionHandler.signinExceptionHandler(e.code);
    }
  }

  Future<void> logout(bool isLogout) async {
    if (isLogout) {
      await _userDataController.removeUserToken(
          currentUserId, _notificationController.currentToken!);
    }
    _currentUser = null;
    await _localStorageController.removeCurrentUserData();
    await _firebaseAuth.signOut();
  }

  Future<void> restPassword(String email) async {
    try {
      _firebaseAuth.sendPasswordResetEmail(email: email).then(
            (_) => MySnackBar.showGetSnackbar(
              'تم إرسال رسالة تغيير كلمة المرور إلى بريدك الإلكتروني',
              Colors.green,
            ),
          );
    } catch (e) {
      Get.to(
        () => const ErrorPage(
          imageAsset: 'assets/img/error.svg',
          message: '  حدثت مشكلة، يرجى إعادة المحاولة لاحقاً',
        ),
      );
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    var credential = EmailAuthProvider.credential(
        email: _firebaseUser.value!.email!, password: oldPassword);
    await _firebaseUser.value!.reauthenticateWithCredential(credential).then(
      (value) async {
        await _firebaseUser.value!.updatePassword(newPassword).then(
          (_) {
            MySnackBar.showGetSnackbar(
              'تم تغيير كلمة المرور بنجاح\nقم بتسجيل الدخول من جديد',
              Colors.green,
            );
            logout(true);
          },
        );
      },
    ).catchError(
      (error) {
        if (error.code == 'wrong-password') {
          MySnackBar.showGetSnackbar(
            'كلمة المرور غير صحيحة',
            Colors.red,
          );
        } else {
          MySnackBar.showGetSnackbar(
            'حدثت مشكلة، حاول مرة أخرى',
            Colors.red,
          );
        }
      },
    );
  }

  set setCurrentUser(ParentUserModel user) => _currentUser = user;
  ParentUserModel get currentUser => _currentUser!;
  String get currentUserId => _currentUser!.userId!;
  UserType get currentUserType => _currentUser!.userType;
  String get currentUserName => _currentUser!.userName!;
  Gender get currentUserGender => _currentUser!.gender;
  Timestamp get currentUserBirthDate => _currentUser!.birthDate;
  String? get currentUserPersonalImage => _currentUser!.personalImageURL;
  String get currentDoctorSpecialization =>
      (_currentUser as DoctorModel).specialization;
  String get currentDoctorDegree => (_currentUser as DoctorModel).degree;
  bool get isSignedIn =>
      _firebaseUser.value != null && _firebaseUser.value!.emailVerified;
}
