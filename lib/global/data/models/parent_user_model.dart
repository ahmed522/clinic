import 'dart:io';

import 'package:clinic/global/constants/gender.dart';
import 'package:flutter/material.dart';

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
  List<Key> likedPosts = [];
  String? userId;
}