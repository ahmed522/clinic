import 'package:clinic/features/time_line/model/comment_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReplyModel extends CommentModel {
  late String replyId;
  ReplyModel({
    required super.postId,
    required super.comment,
    required super.commentTime,
    required super.writer,
  }) : super();

  @override
  toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data = super.toJson();
    data['reply_id'] = replyId;
    return data;
  }

  ReplyModel.fromSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> commentSnapshot,
      required super.writer})
      : super.fromSnapshot(commentSnapshot: commentSnapshot) {
    replyId = commentSnapshot.data()!['reply_id'];
  }
}
