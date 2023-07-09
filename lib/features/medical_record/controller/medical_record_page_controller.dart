import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/features/medical_record/model/medical_record_model.dart';

import 'package:clinic/global/functions/common_functions.dart';
import 'package:get/get.dart';

class MedicalRecordPageController extends GetxController {
  static MedicalRecordPageController get find => Get.find();
  final AuthenticationController _authenticationController =
      AuthenticationController.find;
  final UserDataController _userDataController = UserDataController.find;

  late final MedicalRecordModel? medicalRecord;
  bool medicalRecordIsSet = false;
  bool loading = true;
  bool errorHappend = false;
  @override
  onReady() async {
    medicalRecordIsSet = false;
    medicalRecord =
        await _userDataController.getUserMedicalRecord(currentUserId);
    if (medicalRecord == null) {
      _updateMedicalRecordIsSet(false);
    } else {
      _updateMedicalRecordIsSet(true);
    }
    super.onReady();
  }

  _updateMedicalRecordIsSet(bool value) {
    medicalRecordIsSet = value;
    loading = false;
    update();
  }

  get currentUserPersonalImage =>
      _authenticationController.currentUserPersonalImage;
  get currentUserName => _authenticationController.currentUserName;
  get currentUserId => _authenticationController.currentUserId;
  get currentUserGender => _authenticationController.currentUserGender;
  get currentUserBirthDate => _authenticationController.currentUserBirthDate;
  get currntUserAge => CommonFunctions.calculateAge(currentUserBirthDate);
}
