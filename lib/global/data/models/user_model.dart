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
    data['user_name'] = userName;
    data['birth_date'] = birthDate;
    data['gender'] = gender.name;
    data['personal_image_URL'] = personalImageURL;

    return data;
  }

  factory UserModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return UserModel.fromJson(data!);
  }
  UserModel.fromJson(Map<String, dynamic> data, {bool isLocalStorage = false}) {
    userType = UserType.user;
    userId = data['uid'];
    email = data['email'];
    userName = data['user_name'];
    birthDate =
        isLocalStorage ? getBirthDate(data['birth_date']) : data['birth_date'];
    gender = (data['gender'] == 'male') ? Gender.male : Gender.female;
    personalImageURL = data['personal_image_URL'];
  }
}
