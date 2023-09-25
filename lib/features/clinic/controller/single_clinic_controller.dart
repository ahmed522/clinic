import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/features/clinic/model/clinic_model.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/constants/clinic_page_mode.dart';
import 'package:clinic/global/data/services/location_services.dart';
import 'package:clinic/features/main_page/pages/main_page.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class SingleClinicController extends GetxController {
  SingleClinicController({
    required this.tempClinic,
    required this.clinicIndex,
    this.mode = ClinicPageMode.editMode,
  });

  static SingleClinicController get find => Get.find();

  final UserDataController _userDataController = UserDataController.find;
  final List<TextEditingController> clinicsPhoneNumbersTextControllers = [];

  final ClinicModel tempClinic;
  final int clinicIndex;
  final ClinicPageMode mode;
  RxBool locationValidation = false.obs;
  bool clinicLocationLoading = false;
  bool loading = false;

  @override
  onReady() {
    if (mode == ClinicPageMode.editMode) {
      locationValidation.value = true;
      // to ensure correct arrangement of week days ============================
      final Map<String, bool> workDays = {};
      workDays.addAll(AppConstants.initialWorkDays);
      workDays.forEach((key, value) {
        workDays[key] = tempClinic.workDays[key]!;
      });
      tempClinic.workDays.clear();
      tempClinic.workDays.addAll(workDays);
      //=========================================== ============================
      for (String number in tempClinic.phoneNumbers) {
        clinicsPhoneNumbersTextControllers
            .add(TextEditingController(text: number));
      }
      update();
    }
    super.onReady();
  }

  updateClinicGovernorate(String item) {
    tempClinic.governorate = item;
    update();
  }

  updateClinicRegion(String item, int index) {
    tempClinic.region = item;
    update();
  }

  updateClinicLocationFromTextField(String? text) {
    if (text != null && text.trim() != '') {
      tempClinic.location = text.trim();
      locationValidation.value = true;
    } else {
      tempClinic.location = null;
      if (tempClinic.locationLatitude == null ||
          tempClinic.locationLongitude == null) {
        locationValidation.value = false;
      }
    }
  }

  getCurrentLocation() async {
    updateClinicLocationLoading(true);
    Map<String, double?> location = await LocationServices.getCurrentLocation();
    if (location['lat'] != null && location['long'] != null) {
      tempClinic.locationLatitude = location['lat'];
      tempClinic.locationLongitude = location['long'];
    }
    if (tempClinic.locationLatitude == null ||
        tempClinic.locationLongitude == null) {
      if (tempClinic.location == null) {
        locationValidation.value = false;
      }
    } else {
      locationValidation.value = true;
    }
    clinicLocationLoading = false;
    update();
  }

  updateClinicLocationLoading(bool value) {
    clinicLocationLoading = value;
    update();
  }

  updateWorkDays(String day) {
    tempClinic.workDays[day] = !tempClinic.workDays[day]!;
    update();
  }

  addNewPhoneNumber([String? text]) {
    clinicsPhoneNumbersTextControllers.add(TextEditingController(text: text));
    update();
  }

  removePhoneNumber(int index) {
    clinicsPhoneNumbersTextControllers[index].dispose();
    clinicsPhoneNumbersTextControllers.removeAt(index);
    if (mode == ClinicPageMode.editMode &&
        index < tempClinic.phoneNumbers.length) {
      tempClinic.phoneNumbers.removeAt(index);
    }
    update();
  }

  addClinicPhoneNumbers() {
    tempClinic.phoneNumbers.clear();
    for (TextEditingController numberController
        in clinicsPhoneNumbersTextControllers) {
      String number = numberController.text;
      if (number.trim() != '' &&
          CommonFunctions.countMatches(number, r'[0-9]') > 4) {
        tempClinic.phoneNumbers.add(number.trim());
      }
    }
  }

  updateLoading(bool value) {
    loading = value;
    update();
  }

  addClinic() async {
    Get.back();
    if (_clinicDataValidator()) {
      updateLoading(true);
      tempClinic.clinicId =
          '${CommonFunctions.currentUserId}-${const Uuid().v4()}';

      addClinicPhoneNumbers();
      tempClinic.checkedDoctor = true;
      await _userDataController.addClinicById(
        tempClinic,
      );
      updateLoading(false);
      Get.until(
        ModalRoute.withName(MainPage.route),
      );
    }
  }

  updateClinic(String doctorId) async {
    Get.back();
    if (_clinicDataValidator()) {
      updateLoading(true);
      addClinicPhoneNumbers();
      await _userDataController.updateClinicById(tempClinic);
      updateLoading(false);
      Get.until(
        ModalRoute.withName(MainPage.route),
      );
    }
  }

  bool _clinicDataValidator() {
    bool clinicLocationIsSet = true;
    bool clinicFormValidation = true;
    if (!tempClinic.formKey.currentState!.validate()) {
      clinicFormValidation = false;
    }
    bool locationCoordinatesIsSet = tempClinic.locationLatitude != null &&
        tempClinic.locationLongitude != null;
    if (tempClinic.location == null && !locationCoordinatesIsSet) {
      clinicLocationIsSet = false;
    }

    if (clinicFormValidation && clinicLocationIsSet) {
      return true;
    }
    return false;
  }
}
