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
import 'package:clinic/features/notifications/model/notification_model.dart';
import 'package:clinic/features/notifications/model/notification_type.dart';
import 'package:clinic/features/settings/model/comment_activity_model.dart';
import 'package:clinic/features/settings/model/post_activity_model.dart';
import 'package:clinic/features/settings/model/reply_activity_model.dart';
import 'package:clinic/features/time_line/model/comment_model.dart';
import 'package:clinic/features/time_line/model/doctor_post_model.dart';
import 'package:clinic/features/time_line/model/parent_post_model.dart';
import 'package:clinic/features/time_line/model/reply_model.dart';
import 'package:clinic/features/time_line/model/user_post_model.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/features/clinic/model/clinic_model.dart';
import 'package:clinic/global/data/models/age.dart';
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
        clinic.doctorId = doctor.userId!;
        clinic.clinicId = clincDocId;
        clinic.specialization = doctor.specialization;
        addClinicById(clinic);
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

  Future changeDoctorDegree(String doctorId, String newDegree) async =>
      _db.collection('doctors').doc(doctorId).update({"degree": newDegree});

  /// ----------------------------------------------------------------------
  ///                                clinics                               -
  /// ----------------------------------------------------------------------

  Future<ClinicModel?> getDoctorSingleClinicById(String clinicId) async {
    ClinicModel? clinic;

    await _db
        .collection('clinics')
        .where(FieldPath.documentId, isEqualTo: clinicId)
        .limit(1)
        .get()
        .then(
      (collectionSnapShot) {
        if (collectionSnapShot.size > 0) {
          clinic = ClinicModel.fromSnapShot(collectionSnapShot.docs.first);
        }
      },
    );
    return clinic;
  }

  Future<List<String>> getDoctorClinicsIdsById(String doctorId) async {
    List<String> clinics = [];
    await _db
        .collection('clinics')
        .where('doctor_id', isEqualTo: doctorId)
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
    List<ClinicModel> clinics = [];
    await _db
        .collection('clinics')
        .where('doctor_id', isEqualTo: doctorId)
        .orderBy('created_time')
        .get()
        .then((collectionSnapShot) {
      for (var singleClinicSnapshot in collectionSnapShot.docs) {
        clinics.add(ClinicModel.fromSnapShot(singleClinicSnapshot));
      }
    });
    return clinics;
  }

  Future<void> addClinicById(ClinicModel newClinic) async {
    Map<String, dynamic> newData = {};
    newData = newClinic.toJson();
    newData['created_time'] = Timestamp.now();
    try {
      final doctorClinicsCollectionReference =
          _db.collection('clinics').doc(newClinic.clinicId);
      await doctorClinicsCollectionReference.set(newData);
    } on Exception {
      CommonFunctions.errorHappened();
    }
  }

  Future<void> updateClinicById(ClinicModel newClinic) async {
    Map<String, dynamic> newData = {};
    newData = newClinic.toJson();
    try {
      await _db.collection('clinics').doc(newClinic.clinicId).update(newData);
    } on Exception {
      CommonFunctions.errorHappened();
    }
  }

  Future<void> deleteClinicById(String clinicId) async {
    try {
      await _db.collection('clinics').doc(clinicId).delete();
    } on Exception {
      CommonFunctions.errorHappened();
    }
  }

  /// ----------------------------------------------------------------------
  ///                           Doctor Profile                             -
  /// ----------------------------------------------------------------------

  Future<int> getDoctorNumberOfPosts(String doctorId) async =>
      await getAllUsersPostsCollection
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

  Future<String> getPostWriterId(String postId) async {
    DocumentSnapshot postSnapshot =
        await getAllUsersPostsCollection.doc(postId).get();
    return postSnapshot.get('uid');
  }

  Future<DoctorPostModel?> getDoctorPostById(
      String currentUserId, String postId,
      [DoctorModel? postWriter]) async {
    DocumentSnapshot postSnapshot =
        await getAllUsersPostsCollection.doc(postId).get();
    if (!postSnapshot.exists) {
      return null;
    }
    DoctorModel writer =
        postWriter ?? await getDoctorById(postSnapshot.get('uid'));
    DoctorPostModel post = DoctorPostModel.fromSnapShot(
      postSnapShot: postSnapshot as DocumentSnapshot<Map<String, dynamic>>,
      writer: writer,
    );
    post.reacted = await isUserReactedPost(currentUserId, postId);
    return post;
  }

  Future<UserPostModel?> getUserPostById(String currentUserId, String postId,
      [UserModel? postWriter]) async {
    DocumentSnapshot postSnapshot =
        await getAllUsersPostsCollection.doc(postId).get();
    if (!postSnapshot.exists) {
      return null;
    }
    UserModel writer = postWriter ?? await getUserById(postSnapshot.get('uid'));
    UserPostModel post = UserPostModel.fromSnapShot(
      postSnapShot: postSnapshot as DocumentSnapshot<Map<String, dynamic>>,
      writer: writer,
    );
    post.reacted = await isUserReactedPost(currentUserId, postId);
    return post;
  }

  Future<ParentPostModel?> getPostById(
      String currentUserId, String postId) async {
    DocumentSnapshot postSnapshot =
        await getAllUsersPostsCollection.doc(postId).get();
    if (!postSnapshot.exists) {
      return null;
    }
    ParentPostModel post;
    if (postSnapshot['user_type'] == 'user') {
      UserModel writer = await getUserById(postSnapshot.get('uid'));
      post = UserPostModel.fromSnapShot(
        postSnapShot: postSnapshot as DocumentSnapshot<Map<String, dynamic>>,
        writer: writer,
      );
    } else {
      DoctorModel writer = await getDoctorById(postSnapshot.get('uid'));
      post = DoctorPostModel.fromSnapShot(
        postSnapShot: postSnapshot as DocumentSnapshot<Map<String, dynamic>>,
        writer: writer,
      );
    }
    post.reacted = await isUserReactedPost(currentUserId, postId);
    return post;
  }

  DocumentReference getPostReactsDocumentById(String postDocumentId) =>
      _db.collection('reacts').doc(postDocumentId);
  CollectionReference getPostReactsCollectionById(String postDocumentId) =>
      getPostReactsDocumentById(postDocumentId).collection('post_reacts');

  CollectionReference get getAllUsersPostsCollection =>
      _db.collection('all_users_posts');
  // ===================== post deletion =====================
  Future deletePostById(String postId) async {
    await _deletePostFromAllUsersPostsCollectionById(postId);
    await _deletePostCommentsFromCommentsCollectionById(postId);
    await _deletePostRepliesFromRepliesCollectionById(postId);
    await _deletePostReactsFromReactsCollectionById(postId);
  }

  _deletePostFromAllUsersPostsCollectionById(String postId) =>
      getAllUsersPostsCollection.doc(postId).delete();
  _deletePostCommentsFromCommentsCollectionById(String postId) =>
      getPostCommentsCollectionById(postId).get().then(
        (snapshot) async {
          for (var commentDoc in snapshot.docs) {
            _deletePostComments(commentDoc);
          }
          await getPostCommentsDocumentById(postId).delete();
        },
      );

  _deletePostRepliesFromRepliesCollectionById(String postId) =>
      _db.collection('replies').where('post_id', isEqualTo: postId).get().then(
        (snapshot) {
          for (QueryDocumentSnapshot doc in snapshot.docs) {
            _deleteCommentReplies(doc.id);
          }
        },
      );
  _deletePostReactsFromReactsCollectionById(String postId) =>
      getPostReactsCollectionById(postId).get().then(
        (snapshot) async {
          for (var doc in snapshot.docs) {
            doc.reference.delete();
          }
          await getPostReactsDocumentById(postId).delete();
        },
      );
  // =====================

  //============== comments =================

  DocumentReference getPostCommentsDocumentById(String postId) =>
      _db.collection('comments').doc(postId);

  CollectionReference getPostCommentsCollectionById(String postId) =>
      getPostCommentsDocumentById(postId).collection('post_comments');

  DocumentReference getCommentDocumentById(
          String postId, String commentDocumentId) =>
      getPostCommentsCollectionById(postId).doc(commentDocumentId);

  CollectionReference get allCommentsReacts =>
      _db.collection('all_comments_reacts');

  DocumentReference getCommentReactsDocumentById(String commentId) =>
      allCommentsReacts.doc(commentId);
  CollectionReference getSingleCommentReactsById(String commentId) =>
      getCommentReactsDocumentById(commentId).collection('comment_reacts');

  Future<bool> isUserReactedComment(
      String uid, String commentDocumentId) async {
    bool reacted = false;
    await getSingleCommentReactsById(commentDocumentId).doc(uid).get().then(
      (snapshot) {
        if (snapshot.exists) {
          reacted = true;
        }
      },
    );
    return reacted;
  }

  Future<CommentModel?> getCommentById(
      String currentUserId, String postId, String commentId,
      [ParentUserModel? commentWriter]) async {
    DocumentSnapshot commentSnapshot =
        await getCommentDocumentById(postId, commentId).get();
    if (!commentSnapshot.exists) {
      return null;
    }
    ParentUserModel writer;
    if (commentWriter != null) {
      writer = commentWriter;
    } else {
      writer = (commentSnapshot['writer_type'] == 'doctor')
          ? await getDoctorById(commentSnapshot.get('uid'))
          : await getUserById(commentSnapshot.get('uid'));
    }
    CommentModel comment = CommentModel.fromSnapshot(
      commentSnapshot:
          commentSnapshot as DocumentSnapshot<Map<String, dynamic>>,
      writer: writer,
    );
    comment.reacted = await isUserReactedComment(currentUserId, commentId);
    return comment;
  }

  // ===================== comment deletion =====================
  Future deleteCommentById(
      String currentUserId, String postId, String commentId) async {
    DocumentReference commentDoc =
        getPostCommentsCollectionById(postId).doc(commentId);
    await _deleteCommentFromCommentsCollectionById(commentDoc);
    await _deleteCommentReplies(commentId);
    await getUserComments(currentUserId).doc(commentId).delete();
  }

  _deleteCommentFromCommentsCollectionById(DocumentReference commentDoc) async {
    _deleteCommentReacts(commentDoc.id);
    commentDoc.delete();
  }

  _deleteCommentReacts(String commentId) {
    getSingleCommentReactsById(commentId).get().then(
      (commentReactsSnapshot) {
        if (commentReactsSnapshot.size > 0) {
          for (var reactDoc in commentReactsSnapshot.docs) {
            reactDoc.reference.delete();
          }
        }
        getCommentReactsDocumentById(commentId).delete();
      },
    );
  }

  _deletePostComments(QueryDocumentSnapshot<Object?> commentDoc) {
    _deleteCommentReacts(commentDoc.id);
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

  CollectionReference get allRepliesReacts =>
      _db.collection('all_replies_reacts');
  DocumentReference getReplyReactsDocumentById(String replyId) =>
      allRepliesReacts.doc(replyId);
  CollectionReference getSingleReplyReactsById(String replyId) =>
      getReplyReactsDocumentById(replyId).collection('reply_reacts');

  Future<bool> isUserReactedReply(String uid, String replyDocumentId) async {
    bool reacted = false;
    await getSingleReplyReactsById(replyDocumentId).doc(uid).get().then(
      (snapshot) {
        if (snapshot.exists) {
          reacted = true;
        }
      },
    );
    return reacted;
  }

  Future<ReplyModel?> getReplyById(
      String currentUserId, String commentId, String replyId,
      [ParentUserModel? replyWriter]) async {
    DocumentSnapshot replySnapshot =
        await getReplyDocumentById(commentId, replyId).get();
    if (!replySnapshot.exists) {
      return null;
    }
    ParentUserModel writer;
    if (replyWriter != null) {
      writer = replyWriter;
    } else {
      writer = (replySnapshot.get('writer_type') == 'doctor')
          ? await getDoctorById(replySnapshot.get('uid'))
          : await getUserById(replySnapshot.get('uid'));
    }
    ReplyModel reply = ReplyModel.fromSnapshot(
      commentSnapshot: replySnapshot as DocumentSnapshot<Map<String, dynamic>>,
      writer: writer,
    );
    reply.reacted = await isUserReactedReply(currentUserId, replyId);
    return reply;
  }

  //================== reply deletion ==================
  Future deleteReplyById(
      String currentUserId, String commentId, String replyId) async {
    DocumentReference replyDoc = getReplyDocumentById(commentId, replyId);
    await _deleteReplyReacts(replyDoc.id);
    await replyDoc.delete();

    getCommentRepliesCollectionById(commentId).get().then(
      (snapshot) {
        if (snapshot.size == 0) {
          getCommentRepliesDocumentById(commentId).delete();
        }
      },
    );
    await getUserReplies(currentUserId).doc(replyId).delete();
  }

  _deleteReplyReacts(String replyId) async {
    await getSingleReplyReactsById(replyId).get().then(
      (replyReactsSnapshot) {
        if (replyReactsSnapshot.size > 0) {
          for (var reactDoc in replyReactsSnapshot.docs) {
            reactDoc.reference.delete();
          }
        }
        getReplyReactsDocumentById(replyId).delete();
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
          _deleteReplyReacts(replyDoc.id);
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

  Future<Map<String, dynamic>?> getMedicalRecordMessage(
      String chatId, String messageId) async {
    try {
      DocumentSnapshot snapshot =
          await getMedicalRecordMessageDocument(chatId, messageId).get();
      Map<String, dynamic> medicalRecordMessageData = {};
      medicalRecordMessageData['age'] = Age.fromJson(snapshot.get('age'));
      medicalRecordMessageData['gender'] =
          snapshot.get('gender') == 'male' ? Gender.male : Gender.female;
      String? moreInfo;
      try {
        moreInfo = snapshot.get('info');
      } on StateError {
        moreInfo = null;
      }
      medicalRecordMessageData['medical_record'] = MedicalRecordModel.fromCloud(
        diseases: await _getUserDiseasesForMessage(chatId, messageId),
        medicines: await _getUserMedicinesForMessage(chatId, messageId),
        surgeries: await _getUserSurgeriesForMessage(chatId, messageId),
        moreInfo: moreInfo,
      );
      return medicalRecordMessageData;
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

  /// ----------------------------------------------------------------------
  ///                            Notifications                             -
  /// ----------------------------------------------------------------------
  Future addNewUserToken(String uid, UserType userType, String token,
      [String? specialization]) async {
    await getUserTokensDocumentById(uid).set(
      {
        'user_type': userType.name,
        'specialization': specialization,
      },
    );
    await getUserTokensCollectionById(uid).doc(token).set(
      {
        'active': true,
      },
    );
  }

  Future removeUserToken(String uid, String token) async =>
      await getUserTokensCollectionById(uid).doc(token).delete();

  Future<List<String>> getUserTokensById(String uid) async {
    List<String> tokens = [];
    await getUserTokensCollectionById(uid).get().then(
      (snapshot) {
        for (var token in snapshot.docs) {
          tokens.add(token.id);
        }
      },
    );
    return tokens;
  }

  Future<List<String>> getDoctorsTokensWithSearchingSpechialization(
    Map<String, dynamic> data,
    Timestamp time,
    String notifierId,
    String notifierName,
    Gender notifierGender,
    UserType notifierType,
  ) async {
    List<String> tokens = [];
    if (data['specialization'] != 'طبيب عام') {
      await usersTokensCollection
          .where('specialization', isEqualTo: data['specialization'])
          .get()
          .then(
        (snapshot) async {
          NotificationModel notification = NotificationModel(
            id: const Uuid().v4(),
            type: NotificationType.searchingForMySpecialization,
            time: time,
            data: data,
            notifierId: notifierId,
            notifierName: notifierName,
            notifierGender: notifierGender,
            notifierType: notifierType,
          );
          for (var doc in snapshot.docs) {
            uploadNotification(notification, doc.id);
            await doc.reference.collection('tokens').get().then(
              (value) {
                for (var token in value.docs) {
                  tokens.add(token.id);
                }
              },
            );
          }
        },
      );
    } else {
      await usersTokensCollection
          .where('user_type', isEqualTo: 'doctor')
          .get()
          .then(
        (snapshot) async {
          NotificationModel notification = NotificationModel(
            id: const Uuid().v4(),
            type: NotificationType.searchingForMySpecialization,
            time: Timestamp.now(),
            data: data,
            notifierId: notifierId,
            notifierName: notifierName,
            notifierGender: notifierGender,
            notifierType: notifierType,
          );
          for (var doc in snapshot.docs) {
            uploadNotification(notification, doc.id);

            await doc.reference.collection('tokens').get().then(
              (value) {
                for (var token in value.docs) {
                  tokens.add(token.id);
                }
              },
            );
          }
        },
      );
    }
    return tokens;
  }

  uploadNotification(NotificationModel notification, String uid) async =>
      getUserNotificationsCollectionById(uid)
          .doc(notification.id)
          .set(notification.toJson());

  updateNotificationSeen(String uid, String notificationId) async =>
      getUserNotificationsCollectionById(uid).doc(notificationId).update({
        'seen': true,
        'seen_time': Timestamp.now(),
      });

  Future<bool> isNewNotifications(String uid) =>
      getUserNotificationsCollectionById(uid)
          .where('seen', isEqualTo: false)
          .limit(1)
          .get()
          .then((snapshot) => snapshot.size > 0);

  CollectionReference getUserTokensCollectionById(String uid) =>
      getUserTokensDocumentById(uid).collection('tokens');
  DocumentReference getUserTokensDocumentById(String uid) =>
      usersTokensCollection.doc(uid);
  CollectionReference get usersTokensCollection =>
      _db.collection('users_tokens');

  DocumentReference getSingleNotificationDocumentById(
          String uid, String notificationId) =>
      getUserNotificationsCollectionById(uid).doc(notificationId);
  CollectionReference getUserNotificationsCollectionById(String uid) =>
      getUserNotificationsDocumentById(uid).collection('notifications');
  DocumentReference getUserNotificationsDocumentById(String uid) =>
      usersNotificationsCollection.doc(uid);
  CollectionReference get usersNotificationsCollection =>
      _db.collection('users_notifications');
//==================================================

  /// ----------------------------------------------------------------------
  ///                               Settings                               -
  /// ----------------------------------------------------------------------

  uploadUserCommentPostActivity(
          String uid, String commentId, PostActivityModel postActivity) =>
      getUserComments(uid).doc(commentId).set(postActivity.toJson());
  uploadUserLikedPostActivity(String uid, PostActivityModel postActivity) =>
      getUserLikedPosts(uid)
          .doc(postActivity.postId)
          .set(postActivity.toJson());
  uploadUserReplyCommentActivity(
          String uid, String replyId, CommentActivityModel commentActivity) =>
      getUserReplies(uid).doc(replyId).set(commentActivity.toJson());
  uploadUserLikedCommentActivity(
          String uid, CommentActivityModel commentActivity) =>
      getUserLikedComments(uid)
          .doc(commentActivity.commentId)
          .set(commentActivity.toJson());
  uploadUserLikedReplyActivity(String uid, ReplyActivityModel replyActivity) =>
      getUserLikedReplies(uid)
          .doc(replyActivity.replyId)
          .set(replyActivity.toJson());

  deleteLikedPostById(String uid, String id) =>
      getUserLikedPosts(uid).doc(id).delete();
  deleteLikedCommentById(String uid, String id) =>
      getUserLikedComments(uid).doc(id).delete();
  deleteLikedReplyById(String uid, String id) =>
      getUserLikedReplies(uid).doc(id).delete();
  deleteCommentActivityById(String uid, String id) =>
      getUserComments(uid).doc(id).delete();
  deleteReplyActivityById(String uid, String id) =>
      getUserReplies(uid).doc(id).delete();

  deleteAllLikedPostsById(String uid) => getUserLikedPosts(uid).get().then(
        (snapshot) async {
          for (var doc in snapshot.docs) {
            await doc.reference.delete();
          }
        },
      );
  deleteAllLikedCommentsById(String uid) =>
      getUserLikedComments(uid).get().then(
        (snapshot) async {
          for (var doc in snapshot.docs) {
            await doc.reference.delete();
          }
        },
      );
  deleteAllLikedRepliesById(String uid) => getUserLikedReplies(uid).get().then(
        (snapshot) async {
          for (var doc in snapshot.docs) {
            await doc.reference.delete();
          }
        },
      );
  deleteAllCommentsActivitiesById(String uid) =>
      getUserComments(uid).get().then(
        (snapshot) async {
          for (var doc in snapshot.docs) {
            await doc.reference.delete();
          }
        },
      );
  deleteAllRepliesActivitiesById(String uid) => getUserReplies(uid).get().then(
        (snapshot) async {
          for (var doc in snapshot.docs) {
            await doc.reference.delete();
          }
        },
      );

  CollectionReference get activitiesCollection => _db.collection("activities");
  DocumentReference getUserActivitiesDocumentById(String uid) =>
      activitiesCollection.doc(uid);
  CollectionReference getUserLikedPosts(String uid) =>
      getUserActivitiesDocumentById(uid).collection('likedPosts');
  CollectionReference getUserComments(String uid) =>
      getUserActivitiesDocumentById(uid).collection('comments');
  CollectionReference getUserLikedComments(String uid) =>
      getUserActivitiesDocumentById(uid).collection('likedComments');
  CollectionReference getUserReplies(String uid) =>
      getUserActivitiesDocumentById(uid).collection('replies');
  CollectionReference getUserLikedReplies(String uid) =>
      getUserActivitiesDocumentById(uid).collection('likedReplies');
}
