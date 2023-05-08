import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserPostModel {
  UserModel user = UserModel();
  String? postId;
  Timestamp? timeStamp;
  String searchingSpecialization = AppConstants.initialDoctorSpecialization;
  Map<String, int> patientAge = {
    'days': 0,
    'months': 0,
    'years': 0,
  };
  Gender patientGender = Gender.male;
  List<String> patientDiseases = [];
  bool isErgent = false;
  String? content;
  bool reacted = false;
  UserPostModel();
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['post_id'] = postId;
    data['uid'] = user.userId;
    data['time_stamp'] = timeStamp;
    data['searching_specialization'] = searchingSpecialization;
    data['patient_age'] = patientAge;
    data['patient_diseases'] = patientDiseases;
    data['patient_gender'] = patientGender.name;
    data['reacts'] = 0;
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
    patientGender =
        postData['patient_gender'] == 'male' ? Gender.male : Gender.female;
    patientDiseases = _getPatientDiseases(postData['patient_diseases']);
    isErgent = postData['is_ergent'];
    content = postData['content'];
    timeStamp = postData['time_stamp'];
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
}
