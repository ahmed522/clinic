import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/features/time_line/controller/post_controller.dart';
import 'package:clinic/features/time_line/model/doctor_post_model.dart';
import 'package:clinic/features/time_line/model/doctor_post_type.dart';
import 'package:clinic/global/widgets/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CreateDoctorPostController extends GetxController {
  static CreateDoctorPostController get find => Get.find();
  final DoctorPostModel postModel = DoctorPostModel();
  final AuthenticationController _authenticationController =
      AuthenticationController.find;
  final PostController _postController = PostController.find;
  final UserDataController _userDataController = UserDataController.find;
  Map<String, bool>? selectedClinics;
  bool loading = false;
  String? tempContent;
  updateDoctorPostTypeGroupValue(DoctorPostType newValue) async {
    updateLoading(true);

    postModel.postType = newValue;
    if (newValue == DoctorPostType.discount ||
        newValue == DoctorPostType.newClinic) {
      if (newValue == DoctorPostType.discount) {
        postModel.discount = 20;
      }
      selectedClinics ??= {
        for (var clinicId in await currentDoctorClinics) clinicId: false
      };
      if (selectedClinics != null) {
        initializeSelectedClinics();
      }
    } else {
      postModel.discount = null;
      selectedClinics = null;
    }
    updateLoading(false);
  }

  incrementDiscount() {
    if (postModel.discount! < 100) {
      postModel.discount = postModel.discount! + 1;
    }
    update();
  }

  decrementDiscount() {
    if (postModel.discount! > 0) {
      postModel.discount = postModel.discount! - 1;
    }
    update();
  }

  updateCheckedClinic(bool value, String clinicId) {
    selectedClinics![clinicId] = value;

    update();
  }

  confirmSelectedClinics() async {
    updateLoading(true);
    Get.back();

    postModel.selectedClinics ??= [];
    selectedClinics!.forEach((key, value) {
      if (value) {
        if (!postModel.selectedClinics!.contains(key)) {
          postModel.selectedClinics!.add(key);
        }
      } else {
        postModel.selectedClinics!.remove(key);
      }
    });

    updateLoading(false);
  }

  initializeSelectedClinics() {
    selectedClinics!.forEach((key, value) => selectedClinics![key] = false);
    update();
  }

  updateLoading(bool value) {
    loading = value;
    update();
  }

  onUploadPostButtonPressed(BuildContext context) async {
    if (tempContent != null && tempContent!.trim() != '') {
      await _uploadPost();
    } else {
      MySnackBar.showSnackBar(context, 'من فضلك اكتب شيئاً');
    }
  }

  _uploadPost() async {
    updateLoading(true);
    postModel.doctorId = currentDoctorId;

    postModel.content = tempContent;
    postModel.timeStamp = Timestamp.now();
    _postController.uploadDoctorPost(postModel);
    updateLoading(false);
    Get.back();
    onDelete();
  }

  Future<List<String>> get currentDoctorClinics async =>
      await _userDataController.getDoctorClinicsIdsById(currentDoctorId);
  get currentDoctorPersonalImage =>
      _authenticationController.currentUserPersonalImage;
  get currentDoctorName => _authenticationController.currentUserName;
  get currentDoctorId => _authenticationController.currentUserId;
}
