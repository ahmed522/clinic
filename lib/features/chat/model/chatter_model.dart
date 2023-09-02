import 'package:clinic/global/constants/user_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatterModel {
  ChatterModel({
    required this.id,
    required this.name,
    required this.userType,
  });
  late final String id;
  late final String name;
  late final UserType userType;
  String? picUrl;
  bool isTyping = false;
  bool blocks = false;
  Timestamp? blocksTime;
  bool isBlocked = false;
  bool deleteChat = false;
  Timestamp? lastDeletionTime;
  bool deletedBefore = false;
  toJson() {
    Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['user_type'] = userType.name;
    data['is_typing'] = isTyping;
    data['blocks'] = blocks;
    data['is_blocked'] = isBlocked;
    data['delete_chat'] = deleteChat;
    data['deleted_before'] = deletedBefore;
    return data;
  }

  ChatterModel.fromJson(Map<String, dynamic> data) {
    id = data['id']!;
    name = data['name']!;
    userType = data['user_type'] == 'doctor' ? UserType.doctor : UserType.user;
    isTyping = data['is_typing'];
    blocks = data['blocks'];
    isBlocked = data['is_blocked'];
    deleteChat = data['delete_chat'];
    deletedBefore = data['deleted_before'];
    blocksTime = data['blocks_time'];
    lastDeletionTime = data['last_deletion_time'];
  }
}
