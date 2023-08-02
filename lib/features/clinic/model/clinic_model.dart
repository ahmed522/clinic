import 'package:clinic/global/constants/am_or_pm.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClinicModel {
  Map<String, bool> workDays = Map<String, bool>.fromIterables(
      AppConstants.weekDays, AppConstants.initialCheckedDays);
  late TimeOfDay openTime;
  late TimeOfDay closeTime;
  late String openTimeFinalMin;
  late String openTimeFinalHour;
  late String closeTimeFinalMin;
  late String closeTimeFinalHour;
  late AMOrPM openTimeAMOrPM;
  late AMOrPM closeTimeAMOrPM;
  late int examineVezeeta;
  late int reexamineVezeeta;
  late String governorate;
  late String region;
  String? location;
  double? locationLatitude;
  double? locationLongitude;
  String? clinicId;
  late int index;
  final formKey = GlobalKey<FormState>();

  ClinicModel({
    required this.index,
    this.governorate = AppConstants.initialClinicGovernorate,
    this.region = AppConstants.initialClinicRegion,
    this.examineVezeeta = AppConstants.initialExamineVezeeta,
    this.reexamineVezeeta = AppConstants.initialReexamineVezeeta,
    this.openTime = AppConstants.initialOpenTime,
    this.closeTime = AppConstants.initialCloseTime,
    this.openTimeFinalMin = AppConstants.initialOpenTimeFinalMin,
    this.openTimeFinalHour = AppConstants.initialOpenTimeFinalHour,
    this.closeTimeFinalMin = AppConstants.initialCloseTimeFinalMin,
    this.closeTimeFinalHour = AppConstants.initialCloseTimeFinalHour,
    this.openTimeAMOrPM = AppConstants.initialAmOrPm,
    this.closeTimeAMOrPM = AppConstants.initialAmOrPm,
  });
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['clinic_id'] = clinicId;
    data['work_days'] = workDays;
    data['open_time_min'] = openTimeFinalMin;
    data['open_time_hour'] = openTimeFinalHour;
    data['open_time_am_or_pm'] = openTimeAMOrPM.name;
    data['close_time_min'] = closeTimeFinalMin;
    data['close_time_hour'] = closeTimeFinalHour;
    data['close_time_am_or_pm'] = closeTimeAMOrPM.name;
    data['examine_vezeeta'] = examineVezeeta;
    data['reexamine_vezeeta'] = reexamineVezeeta;
    data['governorate'] = governorate;
    data['region'] = region;
    data['location'] = location;
    data['location_latitude'] = locationLatitude;
    data['location_longitude'] = locationLongitude;

    return data;
  }

  factory ClinicModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return ClinicModel.fromJson(data!);
  }
  ClinicModel.fromJson(Map<String, dynamic> data) {
    clinicId = data['clinic_id'];
    workDays = _getWorkDays(data['work_days']);
    openTimeFinalMin = data['open_time_min'];
    openTimeFinalHour = data['open_time_hour'];
    openTimeAMOrPM =
        (data['open_time_am_or_pm'] == 'am') ? AMOrPM.am : AMOrPM.pm;
    closeTimeFinalMin = data['close_time_min'];
    closeTimeFinalHour = data['close_time_hour'];
    closeTimeAMOrPM =
        (data['close_time_am_or_pm'] == 'am') ? AMOrPM.am : AMOrPM.pm;
    examineVezeeta = data['examine_vezeeta'];
    reexamineVezeeta = data['reexamine_vezeeta'];
    governorate = data['governorate'];
    region = data['region'];
    location = data['location'];
    locationLatitude = data['location_latitude'];
    locationLongitude = data['location_longitude'];
    openTime =
        setClinicOpenTime(openTimeFinalHour, openTimeFinalMin, openTimeAMOrPM);
    closeTime = setClinicCloseTime(
        closeTimeFinalHour, closeTimeFinalMin, closeTimeAMOrPM);
  }
  _getWorkDays(Map<String, dynamic> workDays) {
    Map<String, bool> days = {};
    workDays.forEach((key, value) {
      days[key] = value.toString() == 'true' ? true : false;
    });
    return days;
  }
}
