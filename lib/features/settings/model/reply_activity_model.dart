import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReplyActivityModel {
  ReplyActivityModel({
    required this.postId,
    required this.commentId,
    required this.replyId,
    required this.replyWriterId,
    required this.replyWriterName,
    required this.replyWriterType,
    required this.replyWriterGender,
    required this.activityTime,
  });
  late final String postId;
  late final String commentId;
  late final String replyId;
  late final String replyWriterId;
  late final String replyWriterName;
  late final UserType replyWriterType;
  late final Gender replyWriterGender;
  late final Timestamp activityTime;

  toJson() {
    Map<String, dynamic> data = {};
    data['post_id'] = postId;
    data['comment_id'] = commentId;
    data['reply_id'] = replyId;
    data['reply_writer_id'] = replyWriterId;
    data['reply_writer_name'] = replyWriterName;
    data['reply_writer_type'] = replyWriterType.name;
    data['reply_writer_gender'] = replyWriterGender.name;
    data['activity_time'] = activityTime;

    return data;
  }

  factory ReplyActivityModel.fromSnapshot(DocumentSnapshot snapshot) {
    return ReplyActivityModel.fromJson(snapshot.data() as Map<String, dynamic>);
  }

  ReplyActivityModel.fromJson(Map<String, dynamic> data) {
    postId = data['post_id'];
    commentId = data['comment_id'];
    replyId = data['reply_id'];
    replyWriterId = data['reply_writer_id'];
    replyWriterName = data['reply_writer_name'];
    replyWriterType = (data['reply_writer_type'] == 'doctor')
        ? UserType.doctor
        : UserType.user;
    replyWriterGender =
        (data['reply_writer_gender'] == 'male') ? Gender.male : Gender.female;
    activityTime = data['activity_time'];
  }
}
