import 'dart:io';

import 'package:clinic/features/authentication/controller/sign_up/common/signup_controller.dart';
import 'package:clinic/features/authentication/pages/sign_up/doctor/clinic/clinic_page.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/data/models/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoctorSignupController extends SignupController {
  static DoctorSignupController get find => Get.find();
  String personalImageValidation = '';
  DoctorModel doctorModel = DoctorModel();
  int currentStep = 0;
  bool doctorValidation = false;
  RxBool locationValidation = false.obs;
  double? latitude, longitude;
  bool clinicLocationLoading = false;
  List<StepState> states = [
    StepState.editing,
    StepState.indexed,
  ];
  final List<ClinicPage> clinics = [];
  List<bool> examineVezeetaValid = [];
  List<bool> reexamineVezeetaValid = [];
  validatePersonalImage(bool valid) {
    if (valid) {
      personalImageValidation = '';
    } else {
      personalImageValidation = 'من فضلك أدخل الصورة الشخصية';
    }
    update();
  }

  @override
  setPersonalImage(File image) {
    doctorModel.personalImage = image;
    update();
  }

  setDoctorMedicalIdImage(File image) {
    doctorModel.medicalIdImage = image;
    update();
  }

  incrementCurrentStep() {
    currentStep++;
    update();
  }

  decrementCurrentStep() {
    currentStep--;
    update();
  }

  updateStates(StepState state0, StepState state1) {
    states[0] = state0;
    states[1] = state1;
    update();
  }

  setDoctorValidation(bool value) {
    doctorValidation = value;
    update();
  }

  @override
  updateGender(Gender gender) {
    doctorModel.gender = gender;
    update();
  }

  @override
  updateAge(int age) {
    doctorModel.age = age;
    update();
  }

  addClinic(ClinicPage clinic) {
    clinics.add(clinic);
    update();
  }

  removeClinic() {
    clinics.removeLast();
    update();
  }

  updateDoctorDegree(String item) {
    doctorModel.degree = item;
    update();
  }

  updateDoctorSpecialization(String item) {
    doctorModel.specialization = item;
    update();
  }

  updateClinicGovernorate(String item, int index) {
    doctorModel.clinics[index].governorate = item;
    update();
  }

  updateClinicRegion(String item, int index) {
    doctorModel.clinics[index].region = item;
    update();
  }

  updateWorkDays(String day, int index) {
    doctorModel.clinics[index].workDays[day] =
        !doctorModel.clinics[index].workDays[day]!;
    update();
  }

  updateClinicLocationFromTextField(String? text, int index) {
    if (text != null && text.trim() != '') {
      doctorModel.clinics[index].location = text.trim();
      locationValidation.value = true;
    } else {
      doctorModel.clinics[index].location = null;
      locationValidation.value = false;
    }
  }

  updateClinicLocationFromCurrentLocation(int index) {
    if (latitude == null || longitude == null) {
      doctorModel.clinics[index].locationLatitude = null;
      doctorModel.clinics[index].locationLongitude = null;
      locationValidation.value = false;
    } else {
      doctorModel.clinics[index].locationLatitude = latitude;
      doctorModel.clinics[index].locationLongitude = longitude;
      locationValidation.value = true;
    }
    clinicLocationLoading = false;
    update();
  }

  updateClinicLocationLoading(bool value) {
    clinicLocationLoading = value;
    update();
  }

  updateExamineVezeetaValidation(bool valid, int index) {
    examineVezeetaValid[index] = valid;
    update();
  }

  updateReexamineVezeetaValidation(bool valid, int index) {
    reexamineVezeetaValid[index] = valid;
    update();
  }
}
