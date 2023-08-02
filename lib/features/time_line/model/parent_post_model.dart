import 'package:clinic/global/constants/user_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ParentPostModel {
  String? postId;
  Timestamp? timeStamp;
  String? content;
  bool reacted = false;
  int reacts = 0;
  bool loading = false;
  UserType? writerType;
}
