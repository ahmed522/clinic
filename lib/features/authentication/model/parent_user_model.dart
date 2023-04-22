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
  set setPassword(String password) => _password = password;
  String? get getPassword => _password;
  List<Key> likedPosts = [];
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['age'] = age;
    data['gender'] = gender.name;
    data['likedPosts'] = likedPosts;
    return data;
  }
}
