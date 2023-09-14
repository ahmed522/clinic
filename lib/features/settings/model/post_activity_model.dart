import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostActivityModel {
  PostActivityModel({
    required this.postId,
    required this.postWriterId,
    required this.postWriterName,
    required this.postWriterType,
    required this.postWriterGender,
    required this.activityTime,
  });
  late final String postId;
  late final String postWriterId;
  late final String postWriterName;
  late final UserType postWriterType;
  late final Gender postWriterGender;
  late final Timestamp activityTime;
  String? id;

  toJson() {
    Map<String, dynamic> data = {};
    data['post_id'] = postId;
    data['post_writer_id'] = postWriterId;
    data['post_writer_name'] = postWriterName;
    data['post_writer_type'] = postWriterType.name;
    data['post_writer_gender'] = postWriterGender.name;
    data['activity_time'] = activityTime;
    return data;
  }

  factory PostActivityModel.fromSnapshot(DocumentSnapshot snapshot) {
    return PostActivityModel.fromJson(snapshot.data() as Map<String, dynamic>);
  }

  PostActivityModel.fromJson(Map<String, dynamic> data) {
    postId = data['post_id'];
    postWriterId = data['post_writer_id'];
    postWriterName = data['post_writer_name'];
    postWriterType = (data['post_writer_type'] == 'doctor')
        ? UserType.doctor
        : UserType.user;
    postWriterGender =
        (data['post_writer_gender'] == 'male') ? Gender.male : Gender.female;
    activityTime = data['activity_time'];
  }
}
