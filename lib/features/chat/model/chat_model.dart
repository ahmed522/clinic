import 'package:clinic/features/chat/model/chatter_model.dart';
import 'package:clinic/features/chat/model/message_model.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  ChatModel({
    required this.chatter1,
    required this.chatter2,
    required this.lastMessage,
  }) {
    chattersIds.add(chatter1.id);
    chattersIds.add(chatter2.id);
    chatId = '${chatter1.id} - ${chatter2.id}';
  }
  late final String chatId;
  final List<String> chattersIds = [];
  late final ChatterModel chatter1;
  late final ChatterModel chatter2;
  late MessageModel lastMessage;
  bool chatCreated = false;
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['chat_id'] = chatId;
    data['chatters_ids'] = chattersIds;
    data[chatter1.id] = chatter1.toJson();
    data[chatter2.id] = chatter2.toJson();
    data['last_message'] = lastMessage.toJson();

    return data;
  }

  factory ChatModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return ChatModel.fromJson(data);
  }

  ChatModel.fromJson(Map<String, dynamic> data) {
    chatId = data['chat_id'];
    chattersIds.addAll(_getChattersIds(data['chatters_ids']));
    chatter1 = ChatterModel.fromJson(data[CommonFunctions.currentUserId]);
    String chatterId =
        chattersIds.where((id) => id != CommonFunctions.currentUserId).first;
    chatter2 = ChatterModel.fromJson(data[chatterId]);
    lastMessage = MessageModel.fromJson(data['last_message']);
  }

  List<String> _getChattersIds(List<dynamic> chattersIds) {
    List<String> ids = [];
    for (var id in chattersIds) {
      ids.add(id.toString());
    }
    return ids;
  }
}
