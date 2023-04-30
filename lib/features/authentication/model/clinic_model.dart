import 'package:clinic/global/constants/am_or_pm.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:flutter/material.dart';

class ClinicModel {
  Map<String, bool> workDays = Map<String, bool>.fromIterables(
      AppConstants.weekDays, AppConstants.initialCheckedDays);
  TimeOfDay openTime;
  TimeOfDay closeTime;
  String openTimeFinalMin;
  String openTimeFinalHour;
  String closeTimeFinalMin;
  String closeTimeFinalHour;
  AMOrPM openTimeAMOrPM;
  AMOrPM closeTimeAMOrPM;
  int examineVezeeta;
  int reexamineVezeeta;
  String governorate;
  String region;
  String? location;
  final formKey = GlobalKey<FormState>();

  ClinicModel({
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
    return data;
  }
}
