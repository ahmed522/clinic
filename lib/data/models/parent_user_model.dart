import 'dart:io';

import 'package:clinic/global/constants/gender.dart';

class ParentUserModel {
  String? firstName;
  String? lastName;
  String? email;
  String? _password;
  int? age;
  Gender gender = Gender.male;
  File? personalImage;
  set setPassword(String password) => _password = password;
  String? get getPassword => _password;
}
