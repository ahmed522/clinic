import 'dart:io';

import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/constants/user_type.dart';

class ParentUserModel {
  String? firstName;
  String? lastName;
  String? email;
  String? _password;
  int? age;
  Gender gender = Gender.male;
  File? personalImage;
  String? personalImageURL;
  set setPassword(String password) => _password = password;
  String? get getPassword => _password;
  List<String> likedPosts = [];
  String? userId;
  UserType userType = UserType.user;
}
