import 'dart:io';

import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ParentUserModel {
  String? firstName;
  String? lastName;
  String? email;
  String? _password;
  Timestamp birthDate = Timestamp.now();
  Gender gender = Gender.male;
  File? personalImage;
  String? personalImageURL;
  set setPassword(String password) => _password = password;
  String? get getPassword => _password;
  String? userId;
  UserType userType = UserType.user;

  Timestamp getBirthDate(Map<String, dynamic> birthDate) {
    DateTime date =
        DateTime(birthDate['year']!, birthDate['month']!, birthDate['day']!);
    Timestamp timestamp = Timestamp.fromDate(date);
    return timestamp;
  }
}
