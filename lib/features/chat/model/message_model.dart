import 'package:clinic/features/chat/model/message_state.dart';
import 'package:clinic/features/medical_record/model/medical_record_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  MessageModel({
    required this.messageId,
    required this.senderId,
    required this.recieverId,
    required this.content,
    required this.messageTime,
    this.isMedicalRecordMessage = false,
    this.medicalRecord,
  });
  late final String messageId;
  late final String senderId;
  late final String recieverId;
  late final String content;
  late final Timestamp messageTime;
  MessageState messageState = MessageState.sentOffline;
  bool sendedMessage = true;
  Timestamp? deletionTime;
  late final bool isMedicalRecordMessage;
  MedicalRecordModel? medicalRecord;
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['message_id'] = messageId;
    data['sender_id'] = senderId;
    data['reciever_id'] = recieverId;
    data['content'] = content;
    data['message_time'] = messageTime;
    if (deletionTime != null) {
      data['deletion_time'] = deletionTime;
    }
    data['is_medical_record_message'] = isMedicalRecordMessage;
    data['message_state'] = messageState.name;
    return data;
  }

  factory MessageModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return MessageModel.fromJson(data);
  }

  MessageModel.fromJson(Map<String, dynamic> data) {
    messageId = data['message_id'];
    senderId = data['sender_id'];
    recieverId = data['reciever_id'];
    content = data['content'];
    messageTime = data['message_time'];
    deletionTime = data['deletion_time'];
    isMedicalRecordMessage = data['is_medical_record_message'];
    messageState = _getMessageState(data['message_state']);
  }

  MessageState _getMessageState(String state) {
    switch (state) {
      case 'sentOffline':
        return MessageState.sentOffline;
      case 'sentOnline':
        return MessageState.sentOnline;
      case 'seen':
        return MessageState.seen;
      case 'error':
        return MessageState.error;
      case 'deleted':
        return MessageState.deleted;
      default:
        return MessageState.sentOnline;
    }
  }

  MessageModel.deletedMessage(MessageModel message, Timestamp deletedTime) {
    content = 'تم حذف هذه الرسالة';
    messageId = message.messageId;
    senderId = message.senderId;
    recieverId = message.recieverId;
    messageTime = message.messageTime;
    messageState = MessageState.deleted;
    deletionTime = deletedTime;
    isMedicalRecordMessage = false;
  }
}
