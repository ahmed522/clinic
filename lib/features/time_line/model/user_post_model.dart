import 'package:clinic/features/time_line/model/parent_post_model.dart';
import 'package:clinic/features/time_line/model/patient_gender.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserPostModel extends ParentPostModel {
  UserModel user = UserModel();
  String searchingSpecialization = AppConstants.initialDoctorSpecialization;
  Map<String, int> patientAge = {
    'days': 0,
    'months': 0,
    'years': 0,
  };
  PatientGender patientGender = PatientGender.male;
  List<String> patientDiseases = [];
  bool isErgent = false;
  UserPostModel();
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['post_id'] = postId;
    data['uid'] = user.userId;
    data['user_type'] = 'user';
    data['time_stamp'] = timeStamp;
    data['searching_specialization'] = searchingSpecialization;
    data['patient_age'] = patientAge;
    data['patient_diseases'] = patientDiseases;
    data['patient_gender'] = patientGender.name;
    data['reacts'] = reacts;
    data['content'] = content;
    data['is_ergent'] = isErgent;
    return data;
  }

  UserPostModel.fromSnapShot({
    required DocumentSnapshot<Map<String, dynamic>> postSnapShot,
    required UserModel writer,
  }) {
    final postData = postSnapShot.data();
    user = writer;
    postId = postData!['post_id'];
    searchingSpecialization = postData['searching_specialization'];
    patientAge.addAll(_getPatientAge(postData['patient_age']));
    patientGender = _getPatientGender(postData['patient_gender']);
    patientDiseases = _getPatientDiseases(postData['patient_diseases']);
    isErgent = postData['is_ergent'];
    content = postData['content'];
    timeStamp = postData['time_stamp'];
    reacts = postData['reacts'];
    writerType = UserType.user;
  }

  Map<String, int> _getPatientAge(Map<String, dynamic> patientAge) {
    Map<String, int> map = {};
    map.addEntries([
      MapEntry('days', patientAge['days']),
      MapEntry('months', patientAge['months']),
      MapEntry('years', patientAge['years']),
    ]);
    return map;
  }

  List<String> _getPatientDiseases(List<dynamic> patientDiseases) {
    List<String> diseases = [];
    for (var disease in patientDiseases) {
      diseases.add(disease.toString());
    }
    return diseases;
  }

  PatientGender _getPatientGender(String patientGenderName) {
    switch (patientGenderName) {
      case 'male':
        return PatientGender.male;
      case 'female':
        return PatientGender.female;
      case 'baby':
        return PatientGender.baby;
      default:
        return PatientGender.male;
    }
  }
}
