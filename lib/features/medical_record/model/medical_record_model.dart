import 'package:clinic/features/medical_record/model/disease_model.dart';
import 'package:clinic/features/medical_record/model/medicine_model.dart';
import 'package:clinic/features/medical_record/model/surgery_model.dart';

class MedicalRecordModel {
  final List<DiseaseModel> diseases = [];
  final List<MedicineModel> medicines = [];
  final List<SurgeryModel> surgeries = [];
  String? moreInfo;
  MedicalRecordModel();

  factory MedicalRecordModel.fromCloud({
    required List<DiseaseModel>? diseases,
    required List<MedicineModel>? medicines,
    required List<SurgeryModel>? surgeries,
    String? moreInfo,
  }) {
    MedicalRecordModel medicalRecord = MedicalRecordModel();
    if (diseases != null) {
      medicalRecord.diseases.addAll(diseases);
    }
    if (medicines != null) {
      medicalRecord.medicines.addAll(medicines);
    }
    if (surgeries != null) {
      medicalRecord.surgeries.addAll(surgeries);
    }
    if (moreInfo != null) {
      medicalRecord.moreInfo = moreInfo;
    }
    return medicalRecord;
  }
}
