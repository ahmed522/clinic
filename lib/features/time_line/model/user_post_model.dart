import 'package:clinic/features/authentication/model/user_model.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:flutter/material.dart';

class UserPostModel {
  Key key = UniqueKey();
  UserModel user = UserModel();
  String searchingSpecialization = AppConstants.initialDoctorSpecialization;
  Map<String, int> patientAge = {
    'days': 0,
    'months': 0,
    'years': 0,
  };
  Gender patientGender = Gender.male;
  List<String> patientDiseases = [];
  bool isErgent = false;
  String? content;
  int reacts = 0;
  Map<String, List<String>> comments = {};
}
