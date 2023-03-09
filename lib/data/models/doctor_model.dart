import 'dart:io';

import 'package:clinic/data/models/clinic_model.dart';
import 'package:clinic/data/models/parent_user_model.dart';
import 'package:clinic/global/constants/app_constants.dart';

class DoctorModel extends ParentUserModel {
  String degree = AppConstants.initialDoctorDegree;
  String specialization = AppConstants.initialDoctorSpecialization;
  File? medicalIdImage;
  List<ClinicModel> clinics = [];
}
