import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FollowerModel {
  late final String userId;
  late final UserType userType;
  late final String userName;
  late final Gender gender;
  String? userPersonalImage;
  String? doctorSpecialization;

  FollowerModel({
    required this.userType,
    required this.userId,
    required this.userName,
    required this.gender,
    this.doctorSpecialization,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['follower_type'] = userType.name;
    data['follower_id'] = userId;
    data['follower_name'] = userName;
    data['gender'] = gender.name;
    data['doctor_specialization'] = doctorSpecialization;
    return data;
  }

  factory FollowerModel.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return FollowerModel.fromJson(data);
  }

  FollowerModel.fromJson(Map<String, dynamic>? data) {
    userType = _getUserType(data!['follower_type']);
    userId = data['follower_id'];
    userName = data['follower_name'];
    gender = _getGender(data['gender']);
    doctorSpecialization = data['doctor_specialization'];
  }

  UserType _getUserType(String userTypeName) {
    if (userTypeName == 'user') {
      return UserType.user;
    } else {
      return UserType.doctor;
    }
  }

  Gender _getGender(String doctorGenderName) {
    if (doctorGenderName == 'male') {
      return Gender.male;
    } else {
      return Gender.female;
    }
  }
}
