import 'dart:io';

import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/data/models/clinic_model.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/data/models/parent_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorModel extends ParentUserModel {
  String degree = AppConstants.initialDoctorDegree;
  String specialization = AppConstants.initialDoctorSpecialization;
  File? medicalIdImage;
  String? medicalIdImageURL;
  List<ClinicModel> clinics = [];
  DoctorModel() : super();
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['age'] = age;
    data['gender'] = gender.name;
    data['degree'] = degree;
    data['specialization'] = specialization;
    data['personal_image_URL'] = personalImageURL;
    data['medical_id_image_URL'] = medicalIdImageURL;
    data['uid'] = userId;
    data['user_type'] = userType.name;
    return data;
  }

  factory DoctorModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> doctorSnapshot,
      {List<ClinicModel>? clinics}) {
    final data = doctorSnapshot.data();
    return DoctorModel.fromJson(data!);
  }

  DoctorModel.fromJson(Map<String, dynamic> data,
      {List<ClinicModel>? clinics}) {
    userType = UserType.doctor;
    userId = data['uid'];
    email = data['email'];
    firstName = data['first_name'];
    lastName = data['last_name'];
    age = data['age'];
    gender = (data['gender'] == 'male') ? Gender.male : Gender.female;
    personalImageURL = data['personal_image_URL'];
    medicalIdImageURL = data['medical_id_image_URL'];
    degree = data['degree'];
    specialization = data['specialization'];
    if (clinics != null) {
      this.clinics = clinics;
    } else {
      this.clinics = [];
    }
  }
}
