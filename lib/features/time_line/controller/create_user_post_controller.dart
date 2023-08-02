import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/time_line/controller/post_controller.dart';
import 'package:clinic/features/time_line/model/patient_gender.dart';
import 'package:clinic/features/time_line/model/user_post_model.dart';
import 'package:clinic/features/time_line/pages/post/user_post/disease_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateUserPostController extends GetxController {
  static CreateUserPostController get find => Get.find();
  final postController = Get.lazyPut(() => PostController());
  final UserPostModel postModel = UserPostModel();
  List<DiseaseWidget> diseases = [];
  final AuthenticationController _authenticationController =
      AuthenticationController.find;
  bool maleSelected = true;
  bool femaleSelected = false;
  bool babySelected = false;
  final TextEditingController tempController = TextEditingController();

  String? tempDiseaseName;
  String? tempContent;

  updateNumberOfYears(int years) {
    postModel.patientAge['years'] = years;
    update();
  }

  updateNumberOfMonths(int months) {
    postModel.patientAge['months'] = months;
    update();
  }

  updateNumberOfDays(int days) {
    postModel.patientAge['days'] = days;
    update();
  }

  updateTempDiseaseName(String diseaseName) {
    tempDiseaseName = diseaseName;
    update();
  }

  addDisease() {
    postModel.patientDiseases.add(tempDiseaseName!.trim());
    update();
  }

  addDiseaseWidget(int index, DiseaseWidget diseaseWidget) {
    diseases.insert(index, diseaseWidget);
    update();
  }

  removeDisease(String diseaseName) {
    postModel.patientDiseases.removeWhere(
      (patientDisease) => patientDisease == diseaseName,
    );
    update();
  }

  removeDiseaseWidget(Key key) {
    diseases.removeWhere((disease) => disease.key == key);
    update();
  }

  updateDisease(int index, String diseaseName) {
    postModel.patientDiseases[index] = diseaseName;
    update();
  }

  onMalePressed() {
    maleSelected = true;
    femaleSelected = false;
    babySelected = false;

    postModel.patientGender = PatientGender.male;
    update();
  }

  onFemalePressed() {
    femaleSelected = true;
    maleSelected = false;
    babySelected = false;
    postModel.patientGender = PatientGender.female;
    update();
  }

  onBabyPressed() {
    babySelected = true;
    maleSelected = false;
    femaleSelected = false;
    postModel.patientGender = PatientGender.baby;
    update();
  }

  updateErgentCase(bool isErgent) {
    postModel.isErgent = isErgent;
    update();
  }

  updateSearchingSpecialization(String specialization) {
    postModel.searchingSpecialization = specialization;
    update();
  }

  updateTempControllerText(String diseaseName) {
    tempController.text = diseaseName;
    update();
  }

  String get currentUserId => _authenticationController.currentUserId;
  String get currentUserName => _authenticationController.currentUserName;
  String? get currentUserPersonalImage =>
      _authenticationController.currentUserPersonalImage;
}
