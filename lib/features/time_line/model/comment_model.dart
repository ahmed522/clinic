import 'package:clinic/global/data/models/parent_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  late String commentId;
  late String postId;
  late String comment;
  late Timestamp commentTime;
  ParentUserModel writer;
  bool reacted = false;
  CommentModel({
    required this.postId,
    required this.comment,
    required this.commentTime,
    required this.writer,
  });
  toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['comment_id'] = commentId;
    data['post_id'] = postId;
    data['uid'] = writer.userId;
    data['writer_type'] = writer.userType.name;
    data['comment'] = comment;
    data['comment_time'] = commentTime;
    data['reacts'] = 0;
    return data;
  }

  CommentModel.fromSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> commentSnapshot,
      required this.writer}) {
    final commentData = commentSnapshot.data();
    commentId = commentData!['comment_id'];
    postId = commentData['post_id'];
    comment = commentData['comment'];
    commentTime = commentData['comment_time'];
  }
}
