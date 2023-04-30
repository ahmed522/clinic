import 'dart:io';

import 'package:clinic/features/authentication/model/clinic_model.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/data/models/parent_user_model.dart';

class DoctorModel extends ParentUserModel {
  String degree = AppConstants.initialDoctorDegree;
  String specialization = AppConstants.initialDoctorSpecialization;
  File? medicalIdImage;
  String? medicalIdImageURL;
  List<ClinicModel> clinics = [];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['age'] = age;
    data['gender'] = gender.name;
    data['degree'] = degree;
    data['specialization'] = specialization;
    data['personal_image_URL'] = personalImageURL;
    data['medical_id_image_URL'] = medicalIdImageURL;

    return data;
  }
}
