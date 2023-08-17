import 'dart:io';

import 'package:clinic/features/authentication/controller/local_storage_controller.dart';
import 'package:clinic/features/chat/model/chat_model.dart';
import 'package:clinic/features/chat/model/message_model.dart';
import 'package:clinic/features/chat/model/message_state.dart';
import 'package:clinic/features/following/model/follower_model.dart';
import 'package:clinic/features/medical_record/controller/medical_record_page_controller.dart';
import 'package:clinic/features/medical_record/model/disease_model.dart';
import 'package:clinic/features/medical_record/model/medical_record_model.dart';
import 'package:clinic/features/medical_record/model/medicine_model.dart';
import 'package:clinic/features/medical_record/model/surgery_model.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/features/clinic/model/clinic_model.dart';
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
import 'package:uuid/uuid.dart';

class UserDataController extends GetxController {
  static UserDataController get find => Get.find();
  final _db = FirebaseFirestore.instance;

  //==================== data creation ====================
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
      String clincDocId;
      for (var clinic in doctor.clinics) {
        clincDocId = '${doctor.userId}-${const Uuid().v4()}';
        addClinicById(doctor.userId!, clincDocId, clinic);
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
  //=======================================================

  //================= common data =================
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

  Future<String?> getUserPersonalImageURLById(
      String uid, UserType userType) async {
    String collectionName = (userType == UserType.doctor) ? 'doctors' : 'users';
    String? personalImageURL;
    await _db.collection(collectionName).doc(uid).get().then(
      ((value) {
        personalImageURL = value.data()!['personal_image_URL'];
      }),
    );
    return personalImageURL;
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

  CollectionReference get allUsersFollowingCollection =>
      _db.collection('all_users_following');
  CollectionReference getUserFollowingCollectionById(String userId) => _db
      .collection('all_users_following')
      .doc(userId)
      .collection('user_following');

  //===============================================

  //================= doctor data =================

  Future<DoctorModel> getDoctorById(String doctorId) async {
    final doctorDocumentSnapshot =
        await _db.collection('doctors').doc(doctorId).get();
    return DoctorModel.fromSnapShot(
      doctorDocumentSnapshot,
    );
  }

  Future<String> getDoctorSpecializationById(String doctorId) async {
    late final String specialization;
    await _db
        .collection('doctors')
        .doc(doctorId)
        .get()
        .then((value) => specialization = value['specialization']);
    return specialization;
  }

  Future<ClinicModel?> getDoctorSingleClinicById(
      String doctorId, String clinicId) async {
    ClinicModel? clinic;
    final doctorClincsCollectionRef =
        _db.collection('clinics').doc(doctorId).collection('doctor_clinics');
    await doctorClincsCollectionRef
        .where(FieldPath.documentId, isEqualTo: clinicId)
        .limit(1)
        .get()
        .then((collectionSnapShot) {
      clinic = ClinicModel.fromSnapShot(collectionSnapShot.docs.first);
    });
    return clinic;
  }

  Future<List<String>> getDoctorClinicsIdsById(String doctorId) async {
    final doctorClincsCollectionRef =
        _db.collection('clinics').doc(doctorId).collection('doctor_clinics');
    List<String> clinics = [];
    await doctorClincsCollectionRef
        .orderBy('created_time')
        .get()
        .then((collectionSnapShot) {
      for (var singleClinicSnapshot in collectionSnapShot.docs) {
        clinics.add(singleClinicSnapshot.id);
      }
    });
    return clinics;
  }

  Future<List<ClinicModel>> getDoctorClinicsById(String doctorId) async {
    final doctorClincsCollectionRef =
        _db.collection('clinics').doc(doctorId).collection('doctor_clinics');
    List<ClinicModel> clinics = [];
    await doctorClincsCollectionRef
        .orderBy('created_time')
        .get()
        .then((collectionSnapShot) {
      for (var singleClinicSnapshot in collectionSnapShot.docs) {
        clinics.add(ClinicModel.fromSnapShot(singleClinicSnapshot));
      }
    });
    return clinics;
  }

  Future<void> addClinicById(
      String doctorId, String clinicId, ClinicModel newClinic) async {
    Map<String, dynamic> newData = {};
    newClinic.clinicId = clinicId;
    newData = newClinic.toJson();
    newData['created_time'] = Timestamp.now();
    try {
      final doctorClinicsCollectionReference =
          _db.collection('clinics').doc(doctorId).collection('doctor_clinics');
      await doctorClinicsCollectionReference.doc(clinicId).set(newData);
    } on Exception {
      CommonFunctions.errorHappened();
    }
  }

  Future<void> updateClinicById(
      String doctorId, String clinicId, ClinicModel newClinic) async {
    Map<String, dynamic> newData = {};
    newData = newClinic.toJson();
    try {
      final doctorClinicsCollectionReference =
          _db.collection('clinics').doc(doctorId).collection('doctor_clinics');
      await doctorClinicsCollectionReference.doc(clinicId).update(newData);
    } on Exception {
      CommonFunctions.errorHappened();
    }
  }

  Future<void> deleteClinicById(String doctorId, String clinicId) async {
    try {
      final doctorClinicsCollectionReference =
          _db.collection('clinics').doc(doctorId).collection('doctor_clinics');
      await doctorClinicsCollectionReference.doc(clinicId).delete();
      await _deleteClinicFromPostsById(doctorId, clinicId);
    } on Exception {
      CommonFunctions.errorHappened();
    }
  }

  Future<void> _deleteClinicFromPostsById(
      String doctorId, String clinicId) async {
    try {
      await getAllUsersPostsCollection()
          .where('uid', isEqualTo: doctorId)
          .get()
          .then((snapshot) async {
        for (var postSnapshot in snapshot.docs) {
          if (postSnapshot['post_type'] == 'discount' ||
              postSnapshot['post_type'] == 'newClinic') {
            if (postSnapshot['selected_clinics'] != null &&
                postSnapshot['selected_clinics'].contains(clinicId)) {
              List<String> newSelectedClinics = _getNewSelectedClinics(
                  postSnapshot['selected_clinics'], clinicId);
              await getAllUsersPostsCollection()
                  .doc(postSnapshot.id)
                  .update({'selected_clinics': newSelectedClinics});
            }
          }
        }
      });
    } on Exception {
      CommonFunctions.errorHappened();
    }
  }

  /// ----------------------------------------------------------------------
  ///                           Doctor Profile                             -
  /// ----------------------------------------------------------------------

  Future<int> getDoctorNumberOfPosts(String doctorId) async =>
      await getAllUsersPostsCollection()
          .where('uid', isEqualTo: doctorId)
          .count()
          .get()
          .then((snapshot) {
        return snapshot.count;
      });
  Future<int> getDoctorNumberOfFollowers(String doctorId) async =>
      await getDoctorFollowersCollectionById(doctorId)
          .count()
          .get()
          .then((snapshot) {
        return snapshot.count;
      });
  Future<int> getNumberOfFollowing(String userId) async =>
      await getUserFollowingCollectionById(userId)
          .count()
          .get()
          .then((snapshot) {
        return snapshot.count;
      });

  Future followDoctor(FollowerModel follower, FollowerModel following) async {
    try {
      Map<String, dynamic> followerData = follower.toJson();
      Map<String, dynamic> followingData = following.toJson();
      followerData['follow_time'] = Timestamp.now();
      followingData['follow_time'] = Timestamp.now();
      await getDoctorFollowersCollectionById(following.userId)
          .doc(follower.userId)
          .set(followerData);
      await getUserFollowingCollectionById(follower.userId)
          .doc(following.userId)
          .set(followingData);
    } on Exception {
      CommonFunctions.errorHappened();
    }
  }

  Future unFollowDoctor(String doctorId, String userId) async {
    try {
      await getDoctorFollowersCollectionById(doctorId).doc(userId).delete();
      await getUserFollowingCollectionById(userId).doc(doctorId).delete();
    } on Exception {
      CommonFunctions.errorHappened();
    }
  }

  Future<bool> isUserFollowingDoctor(String doctorId, String userId) async {
    bool followed = false;
    await getDoctorFollowersCollectionById(doctorId)
        .where(FieldPath.documentId, isEqualTo: userId)
        .limit(1)
        .get()
        .then((snapshot) {
      if (snapshot.size == 0) {
        followed = false;
      } else {
        followed = true;
      }
    });
    return followed;
  }

  CollectionReference get allDoctorsFollowersCollection =>
      _db.collection('all_doctors_followers');
  CollectionReference getDoctorFollowersCollectionById(String userId) => _db
      .collection('all_doctors_followers')
      .doc(userId)
      .collection('doctor_followers');

  List<String> _getNewSelectedClinics(
      List<dynamic> selectedClinics, String deletedClinicId) {
    List<String> newSelectedClinics = [];
    for (var clinicId in selectedClinics) {
      newSelectedClinics.add(clinicId);
    }
    newSelectedClinics.remove(deletedClinicId);
    return newSelectedClinics;
  }
  //===============================================

  //================= user data =================
  Future<UserModel> getUserById(String userId) async {
    final userDocumentSnapshot =
        await _db.collection('users').doc(userId).get();
    return UserModel.fromSnapShot(userDocumentSnapshot);
  }
  //=============================================

//===================== images =====================
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

  //===================== image deletion =====================
  Future<void> deleteUserPersonalImage(String userId, String imageURL) async {
    final localStorageController = LocalStorageController.find;
    _deleteImageFromCloudStorageByURL(imageURL);
    await _db
        .collection('users')
        .doc(userId)
        .update({'personal_image_URL': null});
    await localStorageController.updatePersonalImage(null);
    await localStorageController.getCurrentUserData();
  }

  Future<void> _deleteImageFromCloudStorageByURL(String imageURL) async {
    final imageStorageRef = FirebaseStorage.instance.refFromURL(imageURL);
    await imageStorageRef.delete();
  }

  //============= update images =============
  Future<bool> updateUserPersonalImage(String userId, UserModel user) async {
    final localStorageController = LocalStorageController.find;
    try {
      if (user.personalImageURL != null) {
        await _deleteImageFromCloudStorageByURL(user.personalImageURL!);
      }
      String? newImageURL = await uploadUserPersonalImage(user);
      await _db
          .collection('users')
          .doc(userId)
          .update({'personal_image_URL': newImageURL});
      await localStorageController.updatePersonalImage(newImageURL);
      await localStorageController.getCurrentUserData();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateDoctorPersonalImage(
      String doctorId, DoctorModel doctor) async {
    final localStorageController = LocalStorageController.find;
    try {
      await _deleteImageFromCloudStorageByURL(doctor.personalImageURL!);
      String? newImageURL = await uploadDoctorPersonalImage(doctor);
      await _db
          .collection('doctors')
          .doc(doctorId)
          .update({'personal_image_URL': newImageURL});
      await localStorageController.updatePersonalImage(newImageURL);
      await localStorageController.getCurrentUserData();
      return true;
    } catch (e) {
      return false;
    }
  }

  //===========================================

  /// ----------------------------------------------------------------------
  ///                              Time Line                               -
  /// ----------------------------------------------------------------------

  //======================== posts ========================
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

  DocumentReference getPostReactsDocumentById(String postDocumentId) =>
      _db.collection('reacts').doc(postDocumentId);
  CollectionReference getPostReactsCollectionById(String postDocumentId) =>
      getPostReactsDocumentById(postDocumentId).collection('post_reacts');

  CollectionReference getAllUsersPostsCollection() =>
      _db.collection('all_users_posts');
  // ===================== post deletion =====================
  Future deletePostById(String postId, bool isDoctorPost) async {
    await _deletePostFromAllUsersPostsCollectionById(postId);
    if (!isDoctorPost) {
      await _deletePostCommentsFromCommentsCollectionById(postId);
      await _deletePostRepliesFromRepliesCollectionById(postId);
    }
    await _deletePostReactsFromReactsCollectionById(postId);
  }

  _deletePostFromAllUsersPostsCollectionById(String postId) async =>
      await getAllUsersPostsCollection().doc(postId).delete();
  _deletePostCommentsFromCommentsCollectionById(String postId) async =>
      await getPostCommentsCollectionById(postId).get().then((snapshot) {
        for (var commentDoc in snapshot.docs) {
          _deletePostComments(commentDoc);
        }
      });

  _deletePostRepliesFromRepliesCollectionById(String postId) async => await _db
          .collection('replies')
          .where('post_id', isEqualTo: postId)
          .get()
          .then(
        (snapshot) {
          for (QueryDocumentSnapshot doc in snapshot.docs) {
            _deleteCommentReplies(doc.id);
          }
        },
      );
  _deletePostReactsFromReactsCollectionById(String postId) async =>
      await getPostReactsCollectionById(postId).get().then((snapshot) {
        for (var doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
  // =====================

  //============== comments =================

  DocumentReference getPostCommentsDocumentById(String postId) =>
      _db.collection('comments').doc(postId);

  CollectionReference getPostCommentsCollectionById(String postId) =>
      getPostCommentsDocumentById(postId).collection('post_comments');

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

  // ===================== comment deletion =====================
  Future deleteCommentById(String postId, String commentId) async {
    DocumentReference commentDoc =
        getPostCommentsCollectionById(postId).doc(commentId);
    await _deleteCommentFromCommentsCollectionById(commentDoc);
    await _deleteCommentReplies(commentId);
  }

  _deleteCommentFromCommentsCollectionById(DocumentReference commentDoc) async {
    _deleteCommentReacts(commentDoc);
    commentDoc.delete();
  }

  _deleteCommentReacts(DocumentReference commentDoc) {
    commentDoc.collection('comment_reacts').get().then((commentReactsSnapshot) {
      if (commentReactsSnapshot.size > 0) {
        for (var reactDoc in commentReactsSnapshot.docs) {
          reactDoc.reference.delete();
        }
      }
    });
  }

  _deletePostComments(QueryDocumentSnapshot<Object?> commentDoc) {
    _deleteCommentReacts(commentDoc.reference);
    commentDoc.reference.delete();
  }
  //===================

  //========= replies ==========

  DocumentReference getCommentRepliesDocumentById(String commentId) =>
      _db.collection('replies').doc(commentId);

  CollectionReference getCommentRepliesCollectionById(String commentId) =>
      getCommentRepliesDocumentById(commentId).collection('comment_replies');

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

  //================== reply deletion ==================
  Future deleteReplyById(String commentId, String replyId) async {
    DocumentReference replyDoc = getReplyDocumentById(commentId, replyId);
    await _deleteReplyReacts(replyDoc);
    await replyDoc.delete();

    getCommentRepliesCollectionById(commentId).get().then((snapshot) {
      if (snapshot.size == 0) {
        getCommentRepliesDocumentById(commentId).delete();
      }
    });
  }

  _deleteReplyReacts(DocumentReference replyDoc) async {
    await replyDoc.collection('reply_reacts').get().then(
      (replyReactsSnapshot) {
        if (replyReactsSnapshot.size > 0) {
          for (var reactDoc in replyReactsSnapshot.docs) {
            reactDoc.reference.delete();
          }
        }
      },
    );
  }

  _deleteCommentReplies(String commentId) {
    getCommentRepliesDocumentById(commentId)
        .collection('comment_replies')
        .get()
        .then(
      (snapshot) {
        for (var replyDoc in snapshot.docs) {
          _deleteReplyReacts(replyDoc.reference);
          replyDoc.reference.delete();
        }
      },
    );
    getCommentRepliesDocumentById(commentId).delete();
  }
  //==================================================

  /// ----------------------------------------------------------------------
  ///                              Medical Record                          -
  /// ----------------------------------------------------------------------
  Future<MedicalRecordModel?> getUserMedicalRecord(String userId) async {
    try {
      QuerySnapshot snapshot = await medicalRecordsCollection
          .where(FieldPath.documentId, isEqualTo: userId)
          .limit(1)
          .get();
      if (snapshot.size == 0) {
        return null;
      }
      String? moreInfo;
      try {
        moreInfo = snapshot.docs.first.get('info');
      } on StateError {
        moreInfo = null;
      }
      return MedicalRecordModel.fromCloud(
        diseases: await _getUserDiseases(userId),
        medicines: await _getUserMedicines(userId),
        surgeries: await _getUserSurgeries(userId),
        moreInfo: moreInfo,
      );
    } on Exception {
      MedicalRecordPageController.find.errorHappend = true;
      MedicalRecordPageController.find.update();
      return null;
    }
  }

  Future<List<DiseaseModel>?> _getUserDiseases(String userId) async {
    List<DiseaseModel> diseases = [];
    QuerySnapshot snapshot = await _getUserDiseasesCollection(userId).get();
    if (snapshot.size == 0) {
      return null;
    }
    for (var disease in snapshot.docs) {
      diseases.add(DiseaseModel.fromSnapshot(
          disease as DocumentSnapshot<Map<String, dynamic>>));
    }
    return diseases;
  }

  Future<List<MedicineModel>?> _getUserMedicines(String userId) async {
    List<MedicineModel> medicines = [];
    QuerySnapshot snapshot = await _getUserMedicinesCollection(userId).get();
    if (snapshot.size == 0) {
      return null;
    }
    for (var medicine in snapshot.docs) {
      medicines.add(MedicineModel.fromSnapshot(
          medicine as DocumentSnapshot<Map<String, dynamic>>));
    }
    return medicines;
  }

  Future<List<SurgeryModel>?> _getUserSurgeries(String userId) async {
    List<SurgeryModel> surgeries = [];
    QuerySnapshot snapshot = await _getUserSurgeriesCollection(userId).get();
    if (snapshot.size == 0) {
      return null;
    }
    for (var surgery in snapshot.docs) {
      surgeries.add(SurgeryModel.fromSnapshot(
          surgery as DocumentSnapshot<Map<String, dynamic>>));
    }
    return surgeries;
  }

  Future<void> removeDisease(String userId, String diseaseId) =>
      _getUserDiseasesCollection(userId).doc(diseaseId).delete();
  Future<void> removeSurgery(String userId, String surgeryId) =>
      _getUserSurgeriesCollection(userId).doc(surgeryId).delete();
  Future<void> removeMedicine(String userId, String medicineId) =>
      _getUserMedicinesCollection(userId).doc(medicineId).delete();

  CollectionReference get medicalRecordsCollection =>
      _db.collection('medical_records');

  CollectionReference _getUserMedicinesCollection(String userId) =>
      medicalRecordsCollection.doc(userId).collection('medicines');
  CollectionReference _getUserDiseasesCollection(String userId) =>
      medicalRecordsCollection.doc(userId).collection('diseases');
  CollectionReference _getUserSurgeriesCollection(String userId) =>
      medicalRecordsCollection.doc(userId).collection('surgeries');

  //==================================================

  /// ----------------------------------------------------------------------
  ///                                  Chats                               -
  /// ----------------------------------------------------------------------

  Future updateMessageStateById(
          String chatId, String messageId, MessageState state) async =>
      await _getMessageDocumentById(chatId, messageId)
          .update({'message_state': state.name});

  Future updateLastMessageState(String chatId, MessageState state) async {
    getChatDocumentById(chatId)
        .update({'last_message.message_state': state.name});
  }

  Future createChat(ChatModel chat) async {
    try {
      await getChatDocumentById(chat.chatId).set(chat.toJson());
    } catch (e) {
      CommonFunctions.errorHappened();
    }
  }

  Future<ChatModel?> getSingleChat(String chatter1Id, String chatter2Id) async {
    ChatModel? chatModel;
    await chatsCollection
        .where(FieldPath.documentId, whereIn: [
          '$chatter1Id - $chatter2Id',
          '$chatter2Id - $chatter1Id',
        ])
        .limit(1)
        .get()
        .then(
          (snapshot) {
            if (snapshot.size == 0) {
              return;
            }
            chatModel = ChatModel.fromSnapshot(snapshot.docs.first);
          },
        );
    return chatModel;
  }

  Future<MessageModel> getChatLastMessage(String chatId) async {
    DocumentSnapshot? lastMessageSnapshot;
    await getChatMessagesCollectionById(chatId)
        .orderBy('message_time', descending: true)
        .limit(1)
        .get()
        .then((snapshot) => lastMessageSnapshot = snapshot.docs.first);
    return MessageModel.fromSnapshot(lastMessageSnapshot!);
  }

  Future<MessageState> uploadMessage(
      MessageModel message, String chatId) async {
    Map<String, dynamic> data = message.toJson();
    data['message_state'] = MessageState.sentOnline.name;
    try {
      await getChatMessagesCollectionById(chatId)
          .doc(message.messageId)
          .set(data);
      message.messageState = MessageState.sentOnline;
      await updateChatLastMessage(message, chatId);
    } catch (e) {
      message.messageState = MessageState.error;
    }
    return message.messageState;
  }

  Future deleteOldMessages(String chatId, Timestamp oldestDeletionTime) async {
    await getChatMessagesCollectionById(chatId)
        .where('message_time', isLessThan: oldestDeletionTime)
        .get()
        .then((snapshot) {
      for (var documentSnapshot in snapshot.docs) {
        documentSnapshot.reference.delete();
      }
    });
  }

  Future updateChatLastMessage(MessageModel lastMessage, String chatId) async {
    await getChatDocumentById(chatId).update({
      'last_message_time': lastMessage.messageTime,
      'last_message': lastMessage.toJson(),
    });
  }

  Stream<bool> isUserTyping(String chatId, String userId) =>
      getChatDocumentById(chatId).snapshots().map<bool>((snapshot) {
        if (snapshot.exists) {
          return snapshot.get(userId);
        } else {
          return false;
        }
      });

  Future setIsUserTyping(String chatId, String userId, bool value) async {
    await getChatDocumentById(chatId).update({'$userId.is_typing': value});
  }

  Future<MessageModel> deleteMessageById(
      String chatId, MessageModel message) async {
    if (message.isMedicalRecordMessage) {
      await getMedicalRecordMessageDocument(chatId, message.messageId)
          .collection('diseases')
          .get()
          .then(
        (snapshot) {
          for (var document in snapshot.docs) {
            document.reference.delete();
          }
        },
      );
      await getMedicalRecordMessageDocument(chatId, message.messageId)
          .collection('surgeries')
          .get()
          .then(
        (snapshot) {
          for (var document in snapshot.docs) {
            document.reference.delete();
          }
        },
      );
      await getMedicalRecordMessageDocument(chatId, message.messageId)
          .collection('medicines')
          .get()
          .then(
        (snapshot) {
          for (var document in snapshot.docs) {
            document.reference.delete();
          }
        },
      );
    }
    await getMedicalRecordMessageDocument(chatId, message.messageId).delete();
    await getChatMessagesCollectionById(chatId).doc(message.messageId).delete();
    MessageModel deletedMessage =
        MessageModel.deletedMessage(message, Timestamp.now());
    await getChatMessagesCollectionById(chatId)
        .doc(message.messageId)
        .set(deletedMessage.toJson());
    return deletedMessage;
  }
  //=================== medical record message ========================

  Future<MedicalRecordModel?> getMedicalRecordMessage(
      String chatId, String messageId) async {
    try {
      DocumentSnapshot snapshot =
          await getMedicalRecordMessageDocument(chatId, messageId).get();

      String? moreInfo;
      try {
        moreInfo = snapshot.get('info');
      } on StateError {
        moreInfo = null;
      }
      return MedicalRecordModel.fromCloud(
        diseases: await _getUserDiseasesForMessage(chatId, messageId),
        medicines: await _getUserMedicinesForMessage(chatId, messageId),
        surgeries: await _getUserSurgeriesForMessage(chatId, messageId),
        moreInfo: moreInfo,
      );
    } on Exception {
      CommonFunctions.errorHappened();
      return null;
    }
  }

  Future<List<DiseaseModel>?> _getUserDiseasesForMessage(
      String chatId, String messageId) async {
    List<DiseaseModel> diseases = [];
    QuerySnapshot snapshot =
        await getMedicalRecordMessageDocument(chatId, messageId)
            .collection('diseases')
            .get();
    if (snapshot.size == 0) {
      return null;
    }
    for (var disease in snapshot.docs) {
      diseases.add(DiseaseModel.fromSnapshot(
          disease as DocumentSnapshot<Map<String, dynamic>>));
    }
    return diseases;
  }

  Future<List<MedicineModel>?> _getUserMedicinesForMessage(
      String chatId, String messageId) async {
    List<MedicineModel> medicines = [];
    QuerySnapshot snapshot =
        await getMedicalRecordMessageDocument(chatId, messageId)
            .collection('medicines')
            .get();
    if (snapshot.size == 0) {
      return null;
    }
    for (var medicine in snapshot.docs) {
      medicines.add(MedicineModel.fromSnapshot(
          medicine as DocumentSnapshot<Map<String, dynamic>>));
    }
    return medicines;
  }

  Future<List<SurgeryModel>?> _getUserSurgeriesForMessage(
      String chatId, String messageId) async {
    List<SurgeryModel> surgeries = [];
    QuerySnapshot snapshot =
        await getMedicalRecordMessageDocument(chatId, messageId)
            .collection('surgeries')
            .get();
    if (snapshot.size == 0) {
      return null;
    }
    for (var surgery in snapshot.docs) {
      surgeries.add(SurgeryModel.fromSnapshot(
          surgery as DocumentSnapshot<Map<String, dynamic>>));
    }
    return surgeries;
  }

  //==============================================================
  CollectionReference get chatsCollection => _db.collection('chats');
  DocumentReference getChatDocumentById(String chatId) =>
      chatsCollection.doc(chatId);
  CollectionReference getChatMessagesCollectionById(String chatId) =>
      getChatDocumentById(chatId).collection('messages');
  DocumentReference _getMessageDocumentById(String chatId, String messageId) =>
      getChatMessagesCollectionById(chatId).doc(messageId);
  DocumentReference getMedicalRecordMessageDocument(
          String chatId, String messageId) =>
      getChatMessagesCollectionById(chatId)
          .doc(messageId)
          .collection('medical_record')
          .doc('medical_record_document');

  //==================================================
}
