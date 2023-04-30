import 'package:clinic/global/data/models/doctor_model.dart';
import 'package:clinic/global/data/models/user_model.dart';
import 'package:clinic/global/widgets/error_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class UserDataController extends GetxController {
  static UserDataController get find => Get.find();
  final _db = FirebaseFirestore.instance;

  createUser(UserModel user) async {
    await _db
        .collection('users')
        .doc(user.userId)
        .set(user.toJson())
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
      for (var clinic in doctor.clinics) {
        await _db
            .collection('doctors')
            .doc(doctor.userId)
            .collection('clinics')
            .add(clinic.toJson());
      }
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
        await imageFileRoot.putFile(user.personalImage!);
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
        await imageFileRoot.putFile(doctor.personalImage!);
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
        await imageFileRoot.putFile(doctor.medicalIdImage!);
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
}
