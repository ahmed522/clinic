import 'dart:io';

import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/data/models/clinic_model.dart';
import 'package:clinic/global/data/models/doctor_model.dart';
import 'package:clinic/global/data/models/parent_user_model.dart';
import 'package:clinic/global/data/models/user_model.dart';
import 'package:clinic/global/functions/common_functions.dart';
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
            imageAsset: 'assets/img/error.svg',
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
      String clincDocId;
      for (var clinic in doctor.clinics) {
        clincDocId = '${doctor.userId}-${clinic.index.toString()}';
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
            imageAsset: 'assets/img/error.svg',
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
              imageAsset: 'assets/img/error.svg',
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
              imageAsset: 'assets/img/error.svg',
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
              imageAsset: 'assets/img/error.svg',
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

  Future<List<ClinicModel>> getDoctorClinicsById(String doctorId) async {
    final doctorClincsCollectionRef =
        _db.collection('clinics').doc(doctorId).collection('doctor_clinics');
    List<ClinicModel> clinics = [];
    await doctorClincsCollectionRef.get().then((collectionSnapShot) {
      collectionSnapShot.docs.map((singleClinicSnapshot) {
        clinics.add(ClinicModel.fromSnapShot(singleClinicSnapshot));
      });
    });
    return clinics;
  }

  Future<DoctorModel> getDoctorById(String doctorId) async {
    final doctorDocumentSnapshot =
        await _db.collection('doctors').doc(doctorId).get();
    return DoctorModel.fromSnapShot(doctorDocumentSnapshot);
  }

  Future<UserModel> getUserById(String userId) async {
    final userDocumentSnapshot =
        await _db.collection('users').doc(userId).get();
    return UserModel.fromSnapShot(userDocumentSnapshot);
  }

  Future<UserType?> getUserTypeById(String uid) async {
    UserType? userType;
    await _db.collection('doctors').doc(uid).get().then(
      ((value) {
        if (value.data() == null) {
          userType = UserType.user;
        } else {
          userType = UserType.doctor;
        }
      }),
    );
    return userType;
  }

  Future<String> getUserNameById(String uid, UserType userType) async {
    String collectionName = (userType == UserType.doctor) ? 'doctors' : 'users';
    String? firstName;
    String? lastName;

    await _db.collection(collectionName).doc(uid).get().then(
      ((value) {
        firstName = value.data()!['first_name'];
        lastName = value.data()!['last_name'];
      }),
    );
    return CommonFunctions.getFullName(firstName!, lastName!);
  }

  Future<String> getUserPersonalImageURLById(
      String uid, UserType userType) async {
    String collectionName = (userType == UserType.doctor) ? 'doctors' : 'users';
    String? personalImageURL;
    await _db.collection(collectionName).doc(uid).get().then(
      ((value) {
        personalImageURL = value.data()!['personal_image_URL'];
      }),
    );
    return personalImageURL!;
  }

  Future<Gender> getUserGenderById(String uid, UserType userType) async {
    String collectionName = (userType == UserType.doctor) ? 'doctors' : 'users';
    Gender? gender;
    await _db.collection(collectionName).doc(uid).get().then(
      ((value) {
        gender =
            (value.data()!['gender'] == 'male') ? Gender.male : Gender.female;
      }),
    );
    return gender!;
  }

  Future<bool> isUserReactedPost(String uid, String postDocumentId) async {
    bool reacted = false;
    await getPostReactsCollectionById(postDocumentId)
        .doc(uid)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        reacted = true;
      }
    });
    return reacted;
  }

  CollectionReference getUsersPostsCollection() =>
      _db.collection('users_posts');
  DocumentReference getUserPostsDocumentById(
          String uid, String postDocumentId) =>
      _db
          .collection('users_posts')
          .doc(uid)
          .collection('user_posts')
          .doc(postDocumentId);
  CollectionReference getPostReactsCollectionById(String postDocumentId) =>
      _db.collection('reacts').doc(postDocumentId).collection('post_reacts');

  CollectionReference getAllUsersPostsCollection() =>
      _db.collection('all_users_posts');
  //============== comments =================

  DocumentReference _getPostCommentsDocumentById(String postId) =>
      _db.collection('comments').doc(postId);

  CollectionReference getPostCommentsCollectionById(String postId) =>
      _getPostCommentsDocumentById(postId).collection('post_comments');

  DocumentReference getCommentDocumentById(
          String postId, String commentDocumentId) =>
      getPostCommentsCollectionById(postId).doc(commentDocumentId);

  Future<bool> isUserReactedComment(
      String uid, String postDocumentId, String commentDocumentId) async {
    bool reacted = false;
    await getCommentDocumentById(postDocumentId, commentDocumentId)
        .collection('comment_reacts')
        .doc(uid)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        reacted = true;
      }
    });
    return reacted;
  }

  //========= Replies ==========

  DocumentReference _getCommentRepliesDocumentById(String commentId) =>
      _db.collection('replies').doc(commentId);

  CollectionReference getCommentRepliesCollectionById(String commentId) =>
      _getCommentRepliesDocumentById(commentId).collection('comment_replies');

  DocumentReference getReplyDocumentById(
          String commentId, String replyDocumentId) =>
      getCommentRepliesCollectionById(commentId).doc(replyDocumentId);

  Future<bool> isUserReactedReply(
      String uid, String commentId, String replyDocumentId) async {
    bool reacted = false;
    await getReplyDocumentById(commentId, replyDocumentId)
        .collection('reply_reacts')
        .doc(uid)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        reacted = true;
      }
    });
    return reacted;
  }

  //=========================================
}
