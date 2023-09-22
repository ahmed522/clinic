import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/features/clinic/model/clinic_model.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:get/get.dart';

class DoctorClinicPageController extends GetxController {
  DoctorClinicPageController(this.clinic);

  static DoctorClinicPageController get find =>
      Get.find<DoctorClinicPageController>();
  RxBool loading = true.obs;
  final ClinicModel clinic;
  @override
  void onReady() async {
    clinic.doctorPic = await UserDataController.find
        .getUserPersonalImageURLById(clinic.doctorId!, UserType.doctor);
    loading.value = false;
    super.onReady();
  }
}
