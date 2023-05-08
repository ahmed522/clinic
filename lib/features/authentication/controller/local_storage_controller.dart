import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/data/models/doctor_model.dart';
import 'package:clinic/global/data/models/user_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorageController extends GetxController {
  static LocalStorageController get find => Get.find();
  final userData = GetStorage();

  initLocalStorage() => GetStorage.init();

  storeCurrentUserData() async {
    final authenticationController = AuthenticationController.find;
    final userDataController = UserDataController.find;
    String uid = authenticationController.getCurrenUserId();
    UserType? userType = await userDataController.getUserTypeById(uid);
    if (userType == UserType.doctor) {
      authenticationController.currentUser =
          await userDataController.getDoctorById(uid);
      _storeUserDataFromJson(
          (authenticationController.currentUser as DoctorModel).toJson());
    } else if (userType == UserType.user) {
      authenticationController.currentUser =
          await userDataController.getUserById(uid);
      _storeUserDataFromJson(
          (authenticationController.currentUser as UserModel).toJson());
    }
  }

  getCurrentUserData() async {
    final authenticationController = AuthenticationController.find;
    if (userData.hasData('uid')) {
      Map<String, dynamic> data =
          Map.fromIterables(userData.getKeys(), userData.getValues());
      UserType userType = (userData.read('user_type') == 'user')
          ? UserType.user
          : UserType.doctor;
      if (userType == UserType.user) {
        authenticationController.currentUser = UserModel.fromJson(data);
      } else {
        authenticationController.currentUser = DoctorModel.fromJson(data);
      }
    } else {
      await storeCurrentUserData();
      Map<String, dynamic> data =
          Map.fromIterables(userData.getKeys(), userData.getValues());
      UserType userType = (userData.read('user_type') == 'user')
          ? UserType.user
          : UserType.doctor;
      if (userType == UserType.user) {
        authenticationController.currentUser = UserModel.fromJson(data);
      } else {
        authenticationController.currentUser = DoctorModel.fromJson(data);
      }
    }
  }

  removeCurrentUserData() async {
    await userData.erase();
  }

  _storeUserDataFromJson(Map<String, dynamic> data) {
    data.forEach((key, value) {
      userData.write(key, value);
    });
  }
}
