import 'package:clinic/features/time_line/model/user_post_model.dart';
import 'package:clinic/features/time_line/pages/post/user_post/disease_widget.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateUserPostController extends GetxController {
  static CreateUserPostController get find => Get.find();

  final UserPostModel postModel = UserPostModel();
  List<DiseaseWidget> diseases = [];

  bool maleSelected = true;
  bool femaleSelected = false;

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
    postModel.patientGender = Gender.male;
    update();
  }

  onFemalePressed() {
    femaleSelected = true;
    maleSelected = false;
    postModel.patientGender = Gender.male;
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
}
