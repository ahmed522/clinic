import 'package:clinic/features/notifications/model/notification_type.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  NotificationModel({
    required this.id,
    required this.type,
    required this.time,
    required this.data,
    required this.notifierId,
    required this.notifierName,
    required this.notifierGender,
    required this.notifierType,
  });
  late final String id;
  late final NotificationType type;
  late final Timestamp time;
  late final Map<String, dynamic> data;
  bool seen = false;
  Timestamp? seenTime;
  late final String notifierId;
  late final String notifierName;
  late final Gender notifierGender;
  late final UserType notifierType;
  String? notifierPic;

  toJson() {
    Map<String, dynamic> notificationData = {};
    notificationData['id'] = id;
    notificationData['type'] = type.name;
    notificationData['time'] = time;
    notificationData['data'] = data;
    notificationData['seen'] = seen;
    notificationData['seen_time'] = seenTime;
    notificationData['notifier_id'] = notifierId;
    notificationData['notifier_name'] = notifierName;
    notificationData['notifier_gender'] = notifierGender.name;
    notificationData['notifier_type'] = notifierType.name;
    return notificationData;
  }

  factory NotificationModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> notificationData =
        snapshot.data() as Map<String, dynamic>;
    return NotificationModel.fromJson(notificationData);
  }

  NotificationModel.fromJson(Map<String, dynamic> notificationData) {
    id = notificationData['id'];
    type = _parseNotificationType(notificationData['type']);
    time = notificationData['time'];
    data = notificationData['data'];
    seen = notificationData['seen'];
    seenTime = notificationData['seen_time'];
    notifierId = notificationData['notifier_id'];
    notifierName = notificationData['notifier_name'];
    notifierGender = notificationData['notifier_gender'] == 'male'
        ? Gender.male
        : Gender.female;
    notifierType = notificationData['notifier_type'] == 'doctor'
        ? UserType.doctor
        : UserType.user;
  }

  NotificationType _parseNotificationType(String value) {
    try {
      return NotificationType.values
          .firstWhere((type) => type.toString().split('.').last == value);
    } catch (_) {
      throw ArgumentError('Invalid NotificationType value: $value');
    }
  }
}
