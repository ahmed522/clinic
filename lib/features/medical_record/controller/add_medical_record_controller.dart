import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/features/medical_record/model/disease_model.dart';
import 'package:clinic/features/medical_record/model/medical_record_model.dart';
import 'package:clinic/features/medical_record/model/medicine.dart';
import 'package:clinic/features/medical_record/model/medicine_model.dart';
import 'package:clinic/features/medical_record/model/surgery_model.dart';
import 'package:clinic/features/medical_record/pages/disease_widget_for_medical_record.dart';
import 'package:clinic/features/medical_record/pages/medicine_widget_for_medical_record.dart';
import 'package:clinic/features/medical_record/pages/surgery_widget_for_medical_record.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddMedicalRecordController extends GetxController {
  AddMedicalRecordController({required this.medicalRecord});
  @override
  void onReady() {
    for (var diseaseModel in medicalRecord.diseases) {
      diseases.add(
          DiseaseWidgetForMedicalRecord(diseaseId: diseaseModel.diseaseId));
    }
    for (var surgeryModel in medicalRecord.surgeries) {
      surgeries.add(
          SurgeryWidgetForMedicalRecord(surgeryId: surgeryModel.surgeryId));
    }
    for (var medicineModel in medicalRecord.medicines) {
      medicines.add(
          MedicineWidgetForMedicalRecord(medicineId: medicineModel.medicineId));
    }
    update();
    super.onReady();
  }

  static AddMedicalRecordController get find => Get.find();
  final AuthenticationController _authenticationController =
      AuthenticationController.find;
  final UserDataController _userDataController = UserDataController.find;
  final MedicalRecordModel medicalRecord;
  List<DiseaseWidgetForMedicalRecord> diseases = [];
  List<SurgeryWidgetForMedicalRecord> surgeries = [];
  List<MedicineWidgetForMedicalRecord> medicines = [];
  String? tempMedicalRecordInfo;
  String? tempDiseaseName;
  String? tempDiseaseInfo;
  String? tempSurgeryName;
  String? tempSurgeryInfo;
  DateTime? tempSurgeryDate;
  String? tempMedicineName;
  Medicine tempMedicineType = Medicine.pills;
  int tempMedicineTimes = 1;
  int tempPerHowMuchDays = 1;
  String? tempMedicineInfo;
  RxBool loading = false.obs;
  /*-------------------- medical record info --------------------*/

  updateTempMedicalRecordInfo(String medicalRecordInfo) {
    tempMedicalRecordInfo = medicalRecordInfo;
  }

  updateMedicalRecordInfo() {
    medicalRecord.moreInfo = tempMedicalRecordInfo;
  }

  /*------------------------- diseases -------------------------*/

  /*--------- create disease ---------*/

  updateTempDiseaseName(String diseaseName) {
    tempDiseaseName = diseaseName;
    update();
  }

  updateTempDiseaseInfo(String diseaseInfo) {
    tempDiseaseInfo = diseaseInfo;
    update();
  }

  addDisease(DiseaseModel disease) {
    medicalRecord.diseases.add(disease);
    diseases.add(DiseaseWidgetForMedicalRecord(
        diseaseId: medicalRecord
            .diseases[medicalRecord.diseases.length - 1].diseaseId));
    tempDiseaseName = null;
    tempDiseaseInfo = null;
    update();
  }

  /*---------------------------------*/

  /*--------- update disease ---------*/

  updateDiseaseName(String diseaseId) {
    int diseaseIndex = medicalRecord.diseases
        .indexWhere((diseaseModel) => diseaseModel.diseaseId == diseaseId);
    medicalRecord.diseases[diseaseIndex].diseaseName = tempDiseaseName!;
    tempDiseaseName = null;
    update();
  }

  updateDiseaseInfo(String diseaseId) {
    int diseaseIndex = medicalRecord.diseases
        .indexWhere((diseaseModel) => diseaseModel.diseaseId == diseaseId);
    medicalRecord.diseases[diseaseIndex].info = tempDiseaseInfo;
    tempDiseaseInfo = null;
    update();
  }

  /*----------------------------------*/

  /*--------- remove disease ---------*/

  removeDisease(String diseaseId) async {
    int index = medicalRecord.diseases
        .indexWhere((diseaseModel) => diseaseModel.diseaseId == diseaseId);
    medicalRecord.diseases.removeAt(index);
    loading.value = true;
    await _userDataController.removeDisease(currentUserId, diseaseId);
    loading.value = false;
    diseases.removeAt(index);
    update();
  }

  /*----------------------------------*/

  /*------------------------- surgeries -------------------------*/

  /*--------- create surgery ---------*/

  updateTempSurgeryName(String surgeryName) {
    tempSurgeryName = surgeryName;
    update();
  }

  updateTempSurgeryInfo(String surgeryInfo) {
    tempSurgeryInfo = surgeryInfo;
    update();
  }

  updateTempSurgeryDate(DateTime surgeryDate) {
    tempSurgeryDate = surgeryDate;
    update();
  }

  Timestamp get surgeyDate => Timestamp.fromDate(tempSurgeryDate!);

  addSurgery(SurgeryModel surgery) {
    medicalRecord.surgeries.add(surgery);
    surgeries.add(SurgeryWidgetForMedicalRecord(
        surgeryId: medicalRecord
            .surgeries[medicalRecord.surgeries.length - 1].surgeryId));
    tempSurgeryName = null;
    tempSurgeryDate = null;
    tempSurgeryInfo = null;
    update();
  }

  /*---------------------------------*/

  /*--------- edit surgery ---------*/

  updateSurgeryName(String surgeryId) {
    int surgeryIndex = medicalRecord.surgeries
        .indexWhere((surgeryModel) => surgeryModel.surgeryId == surgeryId);
    medicalRecord.surgeries[surgeryIndex].surgeryName = tempSurgeryName!;
    tempSurgeryName = null;
    update();
  }

  updateSurgeryDate(String surgeryId) {
    int surgeryIndex = medicalRecord.surgeries
        .indexWhere((surgeryModel) => surgeryModel.surgeryId == surgeryId);
    medicalRecord.surgeries[surgeryIndex].surgeryDate = surgeyDate;
    tempSurgeryDate = null;
    update();
  }

  updateSurgeryInfo(String surgeryId) {
    int surgeryIndex = medicalRecord.surgeries
        .indexWhere((surgeryModel) => surgeryModel.surgeryId == surgeryId);
    medicalRecord.surgeries[surgeryIndex].info = tempSurgeryInfo;
    tempSurgeryInfo = null;
    update();
  }

  /*--------------------------------*/

  /*--------- remove surgery ---------*/

  removeSurgery(String surgeryId) async {
    int index = medicalRecord.surgeries
        .indexWhere((surgeryModel) => surgeryModel.surgeryId == surgeryId);
    medicalRecord.surgeries.removeAt(index);
    loading.value = true;
    await _userDataController.removeSurgery(currentUserId, surgeryId);
    loading.value = false;
    surgeries.removeAt(index);
    update();
  }

  /*----------------------------------*/

  /*------------------------- medicines -------------------------*/

  /*--------- create medicine ---------*/

  updateTempMedicineName(String medicineName) {
    tempMedicineName = medicineName;
    update();
  }

  updateTempMedicineType(Medicine medicineType) {
    tempMedicineType = medicineType;
    update();
  }

  icreamentTempMedicineTimes() {
    if (tempMedicineTimes < 50) {
      ++tempMedicineTimes;
      update();
    }
  }

  decreamentTempMedicineTimes() {
    if (tempMedicineTimes > 1) {
      --tempMedicineTimes;
      update();
    }
  }

  icreamentTempPerHowMuchDays() {
    if (tempPerHowMuchDays < 90) {
      ++tempPerHowMuchDays;
      update();
    }
  }

  decreamentTempPerHowMuchDays() {
    if (tempPerHowMuchDays > 1) {
      --tempPerHowMuchDays;
      update();
    }
  }

  updateTempMedicineInfo(String medicineInfo) {
    tempMedicineInfo = medicineInfo;
    update();
  }

  addMedicine(MedicineModel medicine) {
    medicalRecord.medicines.add(medicine);
    medicines.add(MedicineWidgetForMedicalRecord(
      medicineId: medicalRecord
          .medicines[medicalRecord.medicines.length - 1].medicineId,
    ));
    resetMedicine();
    update();
  }

  resetMedicine() {
    tempMedicineName = null;
    tempMedicineType = Medicine.pills;
    tempMedicineTimes = 1;
    tempPerHowMuchDays = 1;
    tempMedicineInfo = null;
  }

  /*-----------------------------------*/

  /*--------- edit medicine ---------*/

  void updateMedicineName(int medicineIndex) =>
      medicalRecord.medicines[medicineIndex].medicineName = tempMedicineName!;

  void updateMedicineInfo(int medicineIndex) =>
      medicalRecord.medicines[medicineIndex].info = tempMedicineInfo!;

  void updateMedicineType(int medicineIndex) =>
      medicalRecord.medicines[medicineIndex].medicineType = tempMedicineType;

  void updateMedicineTimes(int medicineIndex) =>
      medicalRecord.medicines[medicineIndex].times = tempMedicineTimes;

  void updatePerHowMuchDays(int medicineIndex) =>
      medicalRecord.medicines[medicineIndex].perHowmuchDays =
          tempPerHowMuchDays;

  /*---------------------------------*/

  /*--------- remove medicine ---------*/

  removeMedicine(String medicineId) async {
    int index = medicalRecord.medicines
        .indexWhere((medicineModel) => medicineModel.medicineId == medicineId);
    medicalRecord.medicines.removeAt(index);
    loading.value = true;
    await _userDataController.removeMedicine(currentUserId, medicineId);
    loading.value = false;
    medicines.removeAt(index);
    update();
  }

  /*-----------------------------------*/

  /*------------------------- API -------------------------*/

  /*--------- creation ---------*/

  createMedicalRecord(bool isEditPage) async {
    loading.value = true;
    try {
      await _userDataController.medicalRecordsCollection
          .doc(currentUserId)
          .set({'created': true});
      await _uploadList('diseases');
      await _uploadList('surgeries');
      await _uploadList('medicines');
      await _uploadInfo();
      loading.value = false;
      MySnackBar.showGetSnackbar(
          isEditPage
              ? 'تم تعديل السجل المرضي بنجاح'
              : 'تم إنشاء السجل المرضي بنجاح',
          Colors.green);
    } catch (e) {
      loading.value = false;
      CommonFunctions.errorHappened();
    }
  }

  Future<void> _uploadList(String collectionId) async {
    DocumentReference userMedicalRecordDocument =
        _userDataController.medicalRecordsCollection.doc(currentUserId);
    switch (collectionId) {
      case 'diseases':
        for (var disease in medicalRecord.diseases) {
          await userMedicalRecordDocument
              .collection(collectionId)
              .doc(disease.diseaseId)
              .set(disease.toJson());
        }
        return;
      case 'surgeries':
        for (var surgery in medicalRecord.surgeries) {
          await userMedicalRecordDocument
              .collection(collectionId)
              .doc(surgery.surgeryId)
              .set(surgery.toJson());
        }
        return;
      case 'medicines':
        for (var medicine in medicalRecord.medicines) {
          await userMedicalRecordDocument
              .collection(collectionId)
              .doc(medicine.medicineId)
              .set(medicine.toJson());
        }
        return;
    }
  }

  _uploadInfo() async {
    DocumentReference userMedicalRecordDocument =
        _userDataController.medicalRecordsCollection.doc(currentUserId);
    if (medicalRecord.moreInfo != null &&
        medicalRecord.moreInfo!.trim() == '') {
      medicalRecord.moreInfo = null;
    }
    await userMedicalRecordDocument.set({'info': medicalRecord.moreInfo});
  }
  /*----------------------------*/

  get currentUserPersonalImage =>
      _authenticationController.currentUserPersonalImage;
  get currentUserName => _authenticationController.currentUserName;
  get currentUserId => _authenticationController.currentUserId;
}
