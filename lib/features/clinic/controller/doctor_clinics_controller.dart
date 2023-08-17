import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/features/doctor_profile/controller/doctor_profile_page_controller.dart';
import 'package:clinic/features/clinic/model/clinic_model.dart';
import 'package:clinic/global/widgets/snackbar.dart';
import 'package:clinic/features/main_page/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoctorClinicsController extends GetxController {
  DoctorClinicsController(this.doctorId) {
    doctorProfilePageController = Get.find(tag: doctorId);
  }

  static DoctorClinicsController get find => Get.find();
  final String doctorId;
  RxBool loading = false.obs;
  final UserDataController _userDataController = UserDataController.find;
  late final DoctorProfilePageController doctorProfilePageController;
  @override
  void onReady() async {
    updateLoading(true);

    doctorProfilePageController.currentDoctor.clinics =
        await _userDataController
            .getDoctorClinicsById(doctorProfilePageController.doctorId!);
    updateLoading(false);
    super.onReady();
  }

  updateLoading(bool value) {
    loading.value = value;
  }

  Future<void> deleteClinic(String clinicId) async {
    Get.back();
    updateLoading(true);

    await _userDataController
        .deleteClinicById(doctorProfilePageController.doctorId!, clinicId)
        .whenComplete(
          () =>
              MySnackBar.showGetSnackbar('تم حذف العيادة بنجاح', Colors.green),
        );
    updateLoading(false);
    Get.until(
      ModalRoute.withName(MainPage.route),
    );
  }

  List<ClinicModel> get clinics =>
      doctorProfilePageController.currentDoctor.clinics;
}
