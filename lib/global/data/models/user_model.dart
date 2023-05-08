import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/data/models/parent_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel extends ParentUserModel {
  UserModel() : super();
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_type'] = userType.name;
    data['uid'] = userId;
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
    return UserModel.fromJson(data!);
  }
  UserModel.fromJson(Map<String, dynamic> data) {
    userType = UserType.user;
    userId = data['uid'];
    email = data['email'];
    firstName = data['first_name'];
    lastName = data['last_name'];
    age = data['age'];
    gender = (data['gender'] == 'male') ? Gender.male : Gender.female;
    personalImageURL = data['personal_image_URL'];
  }
}
