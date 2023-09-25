import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/data/models/doctor_model.dart';
import 'package:clinic/global/data/models/user_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorageController extends GetxController {
  static LocalStorageController get find => Get.find();
  final _userData = GetStorage();
  final _userDataController = UserDataController.find;
  initLocalStorage() => GetStorage.init();

  storeCurrentUserData() async {
    final authenticationController = AuthenticationController.find;
    String uid = authenticationController.firebaseUserId;
    UserType? userType = await _userDataController.getUserTypeById(uid);
    if (userType == UserType.doctor) {
      authenticationController.setCurrentUser =
          await _userDataController.getDoctorById(uid);
      Map<String, dynamic> doctorData =
          (authenticationController.currentUser as DoctorModel).toJson();
      doctorData['notify_when_ergent_cases'] = true;
      _storeUserDataFromJson(doctorData);
    } else if (userType == UserType.user) {
      authenticationController.setCurrentUser =
          await _userDataController.getUserById(uid);
      _storeUserDataFromJson(
          (authenticationController.currentUser as UserModel).toJson());
    }
  }

  getCurrentUserData() async {
    final authenticationController = AuthenticationController.find;
    if (_userData.hasData('uid')) {
      Map<String, dynamic> data =
          Map.fromIterables(_userData.getKeys(), _userData.getValues());
      UserType userType = (_userData.read('user_type') == 'user')
          ? UserType.user
          : UserType.doctor;
      if (userType == UserType.user) {
        authenticationController.setCurrentUser =
            UserModel.fromJson(data, isLocalStorage: true);
      } else {
        authenticationController.setCurrentUser =
            DoctorModel.fromJson(data, isLocalStorage: true);
      }
    } else {
      await storeCurrentUserData();
    }
  }

  bool? get notifyWhenErgent =>
      _userData.read<bool>('notify_when_ergent_cases');

  removeCurrentUserData() async {
    await _userData.erase();
  }

  updatePersonalImage(String? newImageURL) async =>
      await _updateGivenData('personal_image_URL', newImageURL);
  updateDoctorDegree(String newDegree) async =>
      await _updateGivenData('degree', newDegree);
  updateNotificationsSettings(bool value) async =>
      await _updateGivenData('notify_when_ergent_cases', value);
  _updateGivenData(String key, dynamic value) async =>
      await _userData.write(key, value);
  _storeUserDataFromJson(Map<String, dynamic> data) {
    data.forEach(
      (key, value) {
        if (key == 'birth_date') {
          value = <String, int>{
            'year': value.toDate().year,
            'month': value.toDate().month,
            'day': value.toDate().day,
          };
        }
        _userData.write(key, value);
      },
    );
  }

  storeDataFromJson(Map<String, dynamic> data) {
    data.forEach(
      (key, value) {
        _userData.write(key, value);
      },
    );
  }
}
