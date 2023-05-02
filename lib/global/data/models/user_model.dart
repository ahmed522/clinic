import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/data/models/parent_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel extends ParentUserModel {
  UserModel() : super();
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['age'] = age;
    data['gender'] = gender.name;
    data['personal_image_URL'] = personalImageURL;
    return data;
  }

  factory UserModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return UserModel()
      ..email = data!['email']
      ..firstName = data['first_name']
      ..lastName = data['last_name']
      ..age = data['age']
      ..gender = (data['gender'] == 'male') ? Gender.male : Gender.female
      ..personalImageURL = data['personal_image_URL'];
  }
}
