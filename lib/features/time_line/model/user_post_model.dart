import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserPostModel {
  UserModel user = UserModel();
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
  int reacts = 0;
  Map<String, List<String>> comments = {};
  UserPostModel();
  UserPostModel.fromSnapShot(
      {required DocumentSnapshot<Map<String, dynamic>> userSnapShot,
      required DocumentSnapshot<Map<String, dynamic>> postSnapShot,
      CollectionReference? commentsCollection}) {
    user = UserModel.fromSnapShot(userSnapShot);
    final postData = postSnapShot.data();
    searchingSpecialization = postData!['searching_specialization'];
    patientAge = postData['patient_age'];
    patientGender =
        postData['patient_gender'] == 'male' ? Gender.male : Gender.female;
    patientDiseases = postData['patient_diseases'];
    isErgent = postData['isErgent'];
    reacts = postData['reacts'];
    content = postData['content'];
    if (commentsCollection != null) {
      commentsCollection.get().then((QuerySnapshot snapshot) {
        snapshot.docs.map((document) {
          comments
              .addEntries([MapEntry(document['comment'], document['replies'])]);
        });
      });
    }
  }
}
