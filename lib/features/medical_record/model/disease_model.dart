import 'package:cloud_firestore/cloud_firestore.dart';

class DiseaseModel {
  late String diseaseId;
  late String diseaseName;
  String? info;
  DiseaseModel(
    this.diseaseId, {
    required this.diseaseName,
    this.info,
  });
  toJson() {
    Map<String, dynamic> data = {};
    data['disease_id'] = diseaseId;
    data['disease_name'] = diseaseName;
    data['info'] = info;
    return data;
  }

  factory DiseaseModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> data = snapshot.data()!;
    return DiseaseModel.fromJson(data);
  }
  DiseaseModel.fromJson(Map<String, dynamic> data) {
    diseaseName = data['disease_name'];
    diseaseId = data['disease_id'];
    info = data['info'];
  }
}
