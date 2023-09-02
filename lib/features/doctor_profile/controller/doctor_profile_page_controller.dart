import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/features/following/model/follower_model.dart';
import 'package:clinic/features/notifications/model/notification_model.dart';
import 'package:clinic/features/notifications/model/notification_type.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/data/models/doctor_model.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class DoctorProfilePageController extends GetxController {
  static DoctorProfilePageController get find => Get.find();
  RxBool loading = true.obs;
  bool followLoading = false;
  late bool followed;
  DoctorProfilePageController(
      {this.doctorId, required this.isCurrentDoctorProfile});
  String? doctorId;
  bool isCurrentDoctorProfile;
  DoctorModel currentDoctor = DoctorModel();
  @override
  void onReady() async {
    loading.value = true;
    if (isCurrentDoctorProfile) {
      doctorId = currentUserId;
      currentDoctor = _authenticationController.currentUser as DoctorModel;
    } else {
      currentDoctor = await _userDataController.getDoctorById(doctorId!);
      followed = await _userDataController.isUserFollowingDoctor(
          doctorId!, currentUserId);
    }
    currentDoctor.numberOfFollowers =
        await currentDoctorNumberOfFollowers(doctorId!);
    currentDoctor.numberOfPosts = await currentDoctorNumberOfPosts(doctorId!);
    currentDoctor.numberOfFollowing =
        await currentDoctorNumberOfFollowing(doctorId!);

    loading.value = false;
    super.onReady();
  }

  updateFollowLoading(bool value) {
    followLoading = value;
    update();
  }

  onFollowDoctorButtonPressed() async {
    updateFollowLoading(true);
    if (followed) {
      await _userDataController.unFollowDoctor(doctorId!, currentUserId);
    } else {
      FollowerModel follower = FollowerModel(
        userType: currentUserType,
        userId: currentUserId,
        userName: currentUserName,
        doctorGender: currentUserGender,
        doctorSpecialization: (currentUserType == UserType.doctor)
            ? currentDoctorSpecialization
            : null,
      );
      FollowerModel following = FollowerModel(
        userType: UserType.doctor,
        userId: doctorId!,
        userName: CommonFunctions.getFullName(
            currentDoctor.firstName!, currentDoctor.lastName!),
        doctorGender: currentDoctor.gender,
        doctorSpecialization: currentDoctor.specialization,
      );
      await _userDataController.followDoctor(follower, following);
      NotificationModel notification = NotificationModel(
        id: const Uuid().v4(),
        type: NotificationType.newFollow,
        time: Timestamp.now(),
        data: {},
        notifierId: currentUserId,
        notifierName: currentUserName,
        notifierGender: currentUserGender,
        notifierType: currentUserType,
      );
      _userDataController.uploadNotification(notification, doctorId!);
    }
    followed = await _userDataController.isUserFollowingDoctor(
        doctorId!, currentUserId);
    updateFollowLoading(false);
  }

  final AuthenticationController _authenticationController =
      AuthenticationController.find;
  final UserDataController _userDataController = UserDataController.find;

  Future<int> currentDoctorNumberOfFollowing(String doctorId) async =>
      await _userDataController.getNumberOfFollowing(doctorId);
  Future<int> currentDoctorNumberOfFollowers(String doctorId) async =>
      await _userDataController.getDoctorNumberOfFollowers(doctorId);
  Future<int> currentDoctorNumberOfPosts(String doctorId) async =>
      await _userDataController.getDoctorNumberOfPosts(doctorId);
  Future<bool> updatePersonalImage() =>
      _userDataController.updateDoctorPersonalImage(doctorId!, currentDoctor);
  UserType get currentUserType => _authenticationController.currentUserType;
  String get currentUserId => _authenticationController.currentUserId;
  String get currentUserName => _authenticationController.currentUserName;
  String? get currentUserPersonalImage =>
      _authenticationController.currentUserPersonalImage;
  Gender get currentUserGender => _authenticationController.currentUserGender;
  String get currentDoctorSpecialization =>
      _authenticationController.currentDoctorSpecialization;
}
