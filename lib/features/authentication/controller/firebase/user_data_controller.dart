import 'dart:io';

import 'package:clinic/global/data/models/doctor_model.dart';
import 'package:clinic/global/data/models/parent_user_model.dart';
import 'package:clinic/global/data/models/user_model.dart';
import 'package:clinic/global/widgets/error_page.dart';
import 'package:clinic/global/widgets/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class UserDataController extends GetxController {
  static UserDataController get find => Get.find();
  final _db = FirebaseFirestore.instance;

  createUser(UserModel user) async {
    await _db
        .collection('users')
        .doc(user.userId)
        .set(user.toJson())
        .whenComplete(
            () => MySnackBar.showGetSnackbar('تم التسجيل بنجاح', Colors.green))
        .catchError((error) {
      Get.to(() => const ErrorPage(
            imageAsset: 'assets/img/error.png',
            message: '  حدثت مشكلة، يرجى إعادة المحاولة لاحقاً',
          ));
    });
  }

  createDoctor(DoctorModel doctor) async {
    try {
      await _db.collection('doctors').doc(doctor.userId).set(doctor.toJson());
      final doctorClinicsCollectionReference = _db
          .collection('clinics')
          .doc(doctor.userId)
          .collection('doctor_clinics');
      for (var clinic in doctor.clinics) {
        final String clincDocId = '${doctor.userId}-${clinic.index.toString()}';
        await doctorClinicsCollectionReference
            .doc(clincDocId)
            .set(clinic.toJson());
      }
      MySnackBar.showGetSnackbar(
        'تم التسجيل بنجاح',
        Colors.green,
      );
    } catch (e) {
      Get.to(() => const ErrorPage(
            imageAsset: 'assets/img/error.png',
            message: '  حدثت مشكلة، يرجى إعادة المحاولة لاحقاً',
          ));
    }
  }

  Future<String?> uploadUserPersonalImage(UserModel user) async {
    if (user.personalImage != null) {
      String imageFileName = '${user.userId}-personalimage';
      Reference root =
          FirebaseStorage.instance.ref().child('users_personal_images');
      Reference imageFileRoot = root.child(imageFileName);
      try {
        await imageFileRoot.putFile(await _compressImage(user));
      } catch (e) {
        Get.to(() => const ErrorPage(
              imageAsset: 'assets/img/error.png',
              message:
                  'حدثت مشكلة في تحميل الصورة الشخصية، يرجى إعادة المحاولة لاحقاً',
            ));
      }
      return imageFileRoot.getDownloadURL();
    }
    return null;
  }

  Future<String?> uploadDoctorPersonalImage(DoctorModel doctor) async {
    if (doctor.personalImage != null) {
      String imageFileName = '${doctor.userId}-personalimage';
      Reference root =
          FirebaseStorage.instance.ref().child('doctors_personal_images');
      Reference imageFileRoot = root.child(imageFileName);
      try {
        await imageFileRoot.putFile(await _compressImage(doctor));
      } catch (e) {
        Get.to(() => const ErrorPage(
              imageAsset: 'assets/img/error.png',
              message:
                  'حدثت مشكلة في تحميل الصورة الشخصية، يرجى إعادة المحاولة لاحقاً',
            ));
      }
      return imageFileRoot.getDownloadURL();
    }
    return null;
  }

  Future<String?> uploadDoctorMedicalIdImage(DoctorModel doctor) async {
    if (doctor.personalImage != null) {
      String imageFileName = '${doctor.userId}-medicalidimage';
      Reference root =
          FirebaseStorage.instance.ref().child('doctors_medical_id_images');
      Reference imageFileRoot = root.child(imageFileName);
      try {
        await imageFileRoot
            .putFile(await _compressImage(doctor, isMedicalIdImage: true));
      } catch (e) {
        Get.to(() => const ErrorPage(
              imageAsset: 'assets/img/error.png',
              message:
                  'حدثت مشكلة في تحميل الصورة الشخصية، يرجى إعادة المحاولة لاحقاً',
            ));
      }
      return imageFileRoot.getDownloadURL();
    }
    return null;
  }

  Future<File> _compressImage(ParentUserModel user,
      {bool isMedicalIdImage = false}) async {
    img.Image? imageFile;
    final File? compressedImageFile;
    final tempDirectory = await getTemporaryDirectory();
    final String path = tempDirectory.path;
    if (user is UserModel) {
      imageFile = img.decodeImage(user.personalImage!.readAsBytesSync());
    } else {
      user as DoctorModel;
      if (isMedicalIdImage) {
        imageFile = img.decodeImage(user.medicalIdImage!.readAsBytesSync());
      } else {
        imageFile = img.decodeImage(user.personalImage!.readAsBytesSync());
      }
    }
    if (isMedicalIdImage) {
      compressedImageFile = File('$path/${user.userId}-medicalIdImage.jpg')
        ..writeAsBytesSync(
          img.encodeJpg(imageFile!, quality: 50),
        );
    } else {
      compressedImageFile = File('$path/${user.userId}-personalImage.jpg')
        ..writeAsBytesSync(
          img.encodeJpg(imageFile!, quality: 50),
        );
    }
    return compressedImageFile;
  }
}
