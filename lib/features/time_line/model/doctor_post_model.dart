import 'package:clinic/features/time_line/model/doctor_post_type.dart';
import 'package:clinic/features/time_line/model/parent_post_model.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/data/models/doctor_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorPostModel extends ParentPostModel {
  String? doctorId;
  DoctorPostType postType = DoctorPostType.other;
  int? discount;
  List<String>? selectedClinics;
  DoctorModel? writer;

  DoctorPostModel();
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_type'] = 'doctor';
    data['post_id'] = postId;
    data['uid'] = doctorId;
    data['time_stamp'] = timeStamp;
    data['content'] = content;
    data['post_type'] = postType.name;
    data['reacts'] = 0;
    if (postType == DoctorPostType.discount) {
      data['discount'] = discount;
      data['selected_clinics'] = selectedClinics;
    } else if (postType == DoctorPostType.newClinic) {
      data['selected_clinics'] = selectedClinics;
    }
    return data;
  }

  factory DoctorPostModel.fromSnapShot({
    required DocumentSnapshot<Map<String, dynamic>> postSnapShot,
    required DoctorModel writer,
  }) {
    final postData = postSnapShot.data();
    DoctorPostModel post = DoctorPostModel.fromJson(postData: postData!);
    post.writer = writer;
    return post;
  }
  DoctorPostModel.fromJson({required Map<String, dynamic> postData}) {
    postId = postData['post_id'];
    doctorId = postData['uid'];
    content = postData['content'];
    timeStamp = postData['time_stamp'];
    postType = _getPostType(postData['post_type']);
    reacts = postData['reacts'];
    writerType = UserType.doctor;
    if (postType == DoctorPostType.discount ||
        postType == DoctorPostType.newClinic) {
      if (postType == DoctorPostType.discount) {
        discount = postData['discount'];
      }
      if (postData['selected_clinics'] != null) {
        selectedClinics = _getClinics(postData['selected_clinics']);
      }
    }
  }

  DoctorPostType _getPostType(String postTypeName) {
    switch (postTypeName) {
      case 'discount':
        return DoctorPostType.discount;
      case 'medicalInfo':
        return DoctorPostType.medicalInfo;
      case 'newClinic':
        return DoctorPostType.newClinic;
      default:
        return DoctorPostType.other;
    }
  }

  List<String> _getClinics(List<dynamic> doctorClinics) {
    List<String> clinics = [];
    for (var clinic in doctorClinics) {
      clinics.add(clinic.toString());
    }
    return clinics;
  }
}
