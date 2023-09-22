import 'dart:io';

import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/features/clinic/model/clinic_model.dart';
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
  int numberOfFollowers = 0;
  int numberOfFollowing = 0;
  int numberOfPosts = 0;
  DoctorModel() : super();
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['user_name'] = userName;
    data['birth_date'] = birthDate;
    data['gender'] = gender.name;
    data['degree'] = degree;
    data['specialization'] = specialization;
    data['personal_image_URL'] = personalImageURL;
    data['medical_id_image_URL'] = medicalIdImageURL;
    data['uid'] = userId;
    data['user_type'] = 'doctor';
    return data;
  }

  DoctorModel copy() {
    DoctorModel copiedDoctor = DoctorModel();

    // Copy fields from the parent class
    copiedDoctor.userName = userName;
    copiedDoctor.email = email;
    copiedDoctor.birthDate = birthDate;
    copiedDoctor.gender = gender;
    copiedDoctor.personalImage = personalImage;
    copiedDoctor.personalImageURL = personalImageURL;
    copiedDoctor.userId = userId;
    copiedDoctor.userType = userType;

    // Copy fields specific to the DoctorModel class
    copiedDoctor.degree = degree;
    copiedDoctor.specialization = specialization;
    copiedDoctor.medicalIdImage = medicalIdImage;
    copiedDoctor.medicalIdImageURL = medicalIdImageURL;
    copiedDoctor.clinics =
        List.from(clinics); // Create a shallow copy of the clinics list
    copiedDoctor.numberOfFollowers = numberOfFollowers;
    copiedDoctor.numberOfFollowing = numberOfFollowing;
    copiedDoctor.numberOfPosts = numberOfPosts;

    return copiedDoctor;
  }

  factory DoctorModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> doctorSnapshot,
      {List<ClinicModel>? clinics}) {
    final data = doctorSnapshot.data();

    return DoctorModel.fromJson(data!, clinics: clinics);
  }

  DoctorModel.fromJson(Map<String, dynamic> data,
      {List<ClinicModel>? clinics, bool isLocalStorage = false}) {
    userType = UserType.doctor;
    userId = data['uid'];
    email = data['email'];
    userName = data['user_name'];
    birthDate =
        isLocalStorage ? getBirthDate(data['birth_date']) : data['birth_date'];
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
