import 'package:clinic/features/medical_record/model/medicine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MedicineModel {
  late final String medicineId;
  late Medicine medicineType;
  late String medicineName;
  String? info;
  late int times;
  late int perHowmuchDays;

  MedicineModel(
    this.medicineId, {
    required this.medicineType,
    required this.medicineName,
    required this.times,
    required this.perHowmuchDays,
    this.info,
  });
  toJson() {
    Map<String, dynamic> data = {};
    data['medicine_id'] = medicineId;
    data['medicine_type'] = medicineType.name;
    data['medicine_name'] = medicineName;
    data['times'] = times;
    data['per_how_much_days'] = perHowmuchDays;
    data['info'] = info;
    return data;
  }

  factory MedicineModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> data = snapshot.data()!;
    return MedicineModel.fromJson(data);
  }

  MedicineModel.fromJson(Map<String, dynamic> data) {
    medicineId = data['medicine_id'];
    medicineType = getMedicineType(data['medicine_type']);
    medicineName = data['medicine_name'];
    times = data['times'];
    perHowmuchDays = data['per_how_much_days'];
    info = data['info'];
  }

  Medicine getMedicineType(String medicineType) {
    switch (medicineType) {
      case 'pills':
        return Medicine.pills;
      case 'syrup':
        return Medicine.syrup;
      case 'syringe':
        return Medicine.syringe;
      case 'cream':
        return Medicine.cream;
      case 'nasalSpray':
        return Medicine.nasalSpray;
      case 'suppository':
        return Medicine.suppository;
      case 'mouthRinse':
        return Medicine.mouthRinse;
      default:
        return Medicine.pills;
    }
  }
}
