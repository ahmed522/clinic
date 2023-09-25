import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClinicModel {
  Map<String, bool> workDays = Map<String, bool>.fromIterables(
      AppConstants.weekDays, AppConstants.initialCheckedDays);
  late Timestamp openTime;
  late Timestamp closeTime;
  late int examineVezeeta;
  late int reexamineVezeeta;
  late String governorate;
  late String region;
  String? specialization;
  String? doctorId;
  String? location;
  double? locationLatitude;
  double? locationLongitude;
  String? clinicId;
  String? doctorName;
  String? doctorPic;
  late bool checkedDoctor;
  Gender doctorGender = Gender.male;
  List<String> phoneNumbers = [];
  late int index;
  final formKey = GlobalKey<FormState>();

  ClinicModel({
    required this.index,
    this.specialization,
    this.doctorId,
    this.governorate = AppConstants.initialClinicGovernorate,
    this.region = AppConstants.initialClinicRegion,
    this.examineVezeeta = AppConstants.initialExamineVezeeta,
    this.reexamineVezeeta = AppConstants.initialReexamineVezeeta,
  }) {
    openTime = CommonFunctions.timestampFromTimeOfDay(
        AppConstants.initialClinicOpenTime);
    closeTime = CommonFunctions.timestampFromTimeOfDay(
        AppConstants.initialClinicCloseTime);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['doctor_id'] = doctorId;
    data['clinic_id'] = clinicId;
    data['specialization'] = specialization;
    data['work_days'] = workDays;
    data['open_time'] = openTime;
    data['close_time'] = closeTime;
    data['examine_vezeeta'] = examineVezeeta;
    data['reexamine_vezeeta'] = reexamineVezeeta;
    data['governorate'] = governorate;
    data['region'] = region;
    data['location'] = location;
    data['location_latitude'] = locationLatitude;
    data['location_longitude'] = locationLongitude;
    data['phone_numbers'] = phoneNumbers;

    return data;
  }

  factory ClinicModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return ClinicModel.fromJson(data!);
  }
  ClinicModel.fromJson(Map<String, dynamic> data) {
    clinicId = data['clinic_id'];
    doctorId = data['doctor_id'];
    specialization = data['specialization'];
    workDays = _getWorkDays(data['work_days']);
    openTime = data['open_time'];
    closeTime = data['close_time'];
    examineVezeeta = data['examine_vezeeta'];
    reexamineVezeeta = data['reexamine_vezeeta'];
    governorate = data['governorate'];
    region = data['region'];
    location = data['location'];
    locationLatitude = data['location_latitude'];
    locationLongitude = data['location_longitude'];
    phoneNumbers = _getPhoneNumbers(data['phone_numbers']);
  }
  factory ClinicModel.copy(ClinicModel other, int index) {
    return ClinicModel(
      index: index,
      specialization: other.specialization,
      doctorId: other.doctorId,
      governorate: other.governorate,
      region: other.region,
      examineVezeeta: other.examineVezeeta,
      reexamineVezeeta: other.reexamineVezeeta,
    )
      ..location = other.location
      ..locationLatitude = other.locationLatitude
      ..locationLongitude = other.locationLongitude
      ..clinicId = other.clinicId
      ..phoneNumbers = List.from(other.phoneNumbers)
      ..workDays = Map.from(other.workDays)
      ..openTime = other.openTime
      ..closeTime = other.closeTime;
  }
  _getWorkDays(Map<String, dynamic> workDays) {
    Map<String, bool> days = {};
    workDays.forEach((key, value) {
      days[key] = value.toString() == 'true' ? true : false;
    });
    return days;
  }

  List<String> _getPhoneNumbers(List<dynamic> clinicPhoneNumbers) {
    List<String> phoneNumbers = [];
    for (var disease in clinicPhoneNumbers) {
      phoneNumbers.add(disease.toString());
    }
    return phoneNumbers;
  }
}
