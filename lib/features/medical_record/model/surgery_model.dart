import 'package:cloud_firestore/cloud_firestore.dart';

class SurgeryModel {
  late String surgeryId;
  late String surgeryName;
  late Timestamp surgeryDate;
  String? info;
  SurgeryModel(
    this.surgeryId, {
    required this.surgeryName,
    required this.surgeryDate,
    this.info,
  });

  toJson() {
    Map<String, dynamic> data = {};
    data['surgery_id'] = surgeryId;
    data['surgery_name'] = surgeryName;
    data['surgery_date'] = surgeryDate;
    data['info'] = info;
    return data;
  }

  factory SurgeryModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> data = snapshot.data()!;
    return SurgeryModel.fromJson(data);
  }

  SurgeryModel.fromJson(Map<String, dynamic> data) {
    surgeryId = data['surgery_id'];
    surgeryName = data['surgery_name'];
    surgeryDate = data['surgery_date'];
    info = data['info'];
  }
}
