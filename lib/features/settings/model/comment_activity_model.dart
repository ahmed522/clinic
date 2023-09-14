import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentActivityModel {
  CommentActivityModel({
    required this.postId,
    required this.commentId,
    required this.commentWriterId,
    required this.commentWriterName,
    required this.commentWriterType,
    required this.commentWriterGender,
    required this.activityTime,
  });
  late final String postId;
  String? postWriterId;
  String? postWriterName;
  UserType? postWriterType;
  Gender? postWriterGender;
  late final String commentId;
  late final String commentWriterId;
  late final String commentWriterName;
  late final UserType commentWriterType;
  late final Gender commentWriterGender;
  late final Timestamp activityTime;
  String? id;

  toJson() {
    Map<String, dynamic> data = {};
    data['post_id'] = postId;
    if (postWriterId != null) {
      data['post_writer_id'] = postWriterId;
    }
    if (postWriterName != null) {
      data['post_writer_name'] = postWriterName;
    }
    if (postWriterType != null) {
      data['post_writer_type'] = postWriterType!.name;
    }
    if (postWriterGender != null) {
      data['post_writer_gender'] = postWriterGender!.name;
    }
    data['comment_id'] = commentId;
    data['comment_writer_id'] = commentWriterId;
    data['comment_writer_name'] = commentWriterName;
    data['comment_writer_type'] = commentWriterType.name;
    data['comment_writer_gender'] = commentWriterGender.name;
    data['activity_time'] = activityTime;
    return data;
  }

  factory CommentActivityModel.fromSnapshot(DocumentSnapshot snapshot) {
    return CommentActivityModel.fromJson(
        snapshot.data() as Map<String, dynamic>);
  }

  CommentActivityModel.fromJson(Map<String, dynamic> data) {
    postId = data['post_id'];
    if (data['post_writer_id'] != null) {
      postWriterId = data['post_writer_id'];
    }
    if (data['post_writer_name'] != null) {
      postWriterName = data['post_writer_name'];
    }
    if (data['post_writer_type'] != null) {
      postWriterType = (data['post_writer_type'] == 'doctor')
          ? UserType.doctor
          : UserType.user;
    }
    if (data['post_writer_gender'] != null) {
      postWriterGender = (data['comment_writer_gender'] == 'male')
          ? Gender.male
          : Gender.female;
    }
    commentId = data['comment_id'];
    commentWriterId = data['comment_writer_id'];
    commentWriterName = data['comment_writer_name'];
    commentWriterType = (data['comment_writer_type'] == 'doctor')
        ? UserType.doctor
        : UserType.user;
    commentWriterGender =
        (data['comment_writer_gender'] == 'male') ? Gender.male : Gender.female;
    activityTime = data['activity_time'];
  }
}
