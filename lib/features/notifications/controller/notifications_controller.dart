import 'dart:convert';
import 'dart:io';
import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/features/chat/controller/single_chat_page_controller.dart';
import 'package:clinic/features/chat/pages/chat_page/single_chat_page.dart';
import 'package:clinic/features/main_page/controller/main_page_controller.dart';
import 'package:clinic/features/notifications/model/notification_model.dart';
import 'package:clinic/features/notifications/model/notification_type.dart';
import 'package:clinic/features/time_line/model/comment_model.dart';
import 'package:clinic/features/time_line/model/doctor_post_model.dart';
import 'package:clinic/features/time_line/model/doctor_post_type.dart';
import 'package:clinic/features/time_line/model/parent_post_model.dart';
import 'package:clinic/features/time_line/model/reply_model.dart';
import 'package:clinic/features/time_line/model/user_post_model.dart';
import 'package:clinic/features/time_line/pages/post/comment/comment_page.dart';
import 'package:clinic/features/time_line/pages/post/comment/reply_page.dart';
import 'package:clinic/features/time_line/pages/post/common/post_page.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/data/models/doctor_model.dart';
import 'package:clinic/global/data/models/parent_user_model.dart';
import 'package:clinic/global/data/models/user_model.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:uuid/uuid.dart';

class NotificationsController extends GetxController {
  static NotificationsController get find => Get.find();
  final AuthenticationController _authenticationController =
      AuthenticationController.find;
  final UserDataController _userDataController = UserDataController.find;
  final _cloudMessaging = FirebaseMessaging.instance;
  late final String? _token;
  Future<void> initNotifications() async {
    await _cloudMessaging.requestPermission();
    _token = await _cloudMessaging.getToken();
    await FlutterNotificationChannel.registerNotificationChannel(
      description: 'users messages',
      id: 'messages',
      importance: NotificationImportance.IMPORTANCE_HIGH,
      name: 'Messages',
    );
    await FlutterNotificationChannel.registerNotificationChannel(
      description: 'news feed notification',
      id: 'timeLine',
      importance: NotificationImportance.IMPORTANCE_HIGH,
      name: 'NewsFeed',
    );
    await _cloudMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      sound: true,
      badge: true,
    );

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    FirebaseMessaging.onMessage.listen(
      (message) {
        Map<String, dynamic> messageData = message.data;
        messageData['chatter_name'] = message.notification!.title;
        if (messageData['type'] == 'chat') {
          _foregroundNotifyNewMessage(messageData);
        } else if (messageData['type'] == 'patient_question') {
          if (Get.isRegistered<MainPageController>()) {
            MainPageController.find.newNotifications.value = true;
          }
          if (messageData['is_ergent'].toString() == 'true') {
            _foregroundNotifyErgentCase(messageData);
          }
        } else {
          if (Get.isRegistered<MainPageController>()) {
            MainPageController.find.newNotifications.value = true;
          }
        }
      },
    );
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        Map<String, dynamic> messageData = message.data;
        messageData['chatter_name'] = message.notification!.title;
        if (messageData['type'] == 'chat') {
          _onOpenNewMessageNotification(messageData);
        } else if (messageData['type'] == 'patient_question') {
          _onOpenPatientQuestionNotification(messageData);
        } else if (messageData['type'] == 'timeLine') {
          if (messageData['sub_type'] == 'react_my_post') {
            _onOpenReactMyPostNotification(messageData);
          } else if (messageData['sub_type'] == 'react_my_comment') {
            _onOpenReactMyCommentNotification(messageData);
          } else if (messageData['sub_type'] == 'react_my_reply') {
            _onOpenReactMyReplyNotification(messageData);
          } else if (messageData['sub_type'] == 'comment_my_post') {
            _onOpenCommentMyPostNotification(messageData);
          } else if (messageData['sub_type'] == 'reply_my_comment') {
            _onOpenReplyMyCommentNotification(messageData);
          }
        }
      },
    );
    _cloudMessaging.getInitialMessage().then(
      (message) {
        if (message != null) {
          Map<String, dynamic> messageData = message.data;
          messageData['chatter_name'] = message.notification!.title;
          if (messageData['type'] == 'chat') {
            _onOpenNewMessageNotification(messageData);
          } else if (messageData['type'] == 'patient_question') {
            _onOpenPatientQuestionNotification(messageData);
          } else if (messageData['type'] == 'timeLine') {
            if (messageData['sub_type'] == 'react_my_post') {
              _onOpenReactMyPostNotification(messageData);
            } else if (messageData['sub_type'] == 'react_my_comment') {
              _onOpenReactMyCommentNotification(messageData);
            } else if (messageData['sub_type'] == 'react_my_reply') {
              _onOpenReactMyReplyNotification(messageData);
            } else if (messageData['sub_type'] == 'comment_my_post') {
              _onOpenCommentMyPostNotification(messageData);
            } else if (messageData['sub_type'] == 'reply_my_comment') {
              _onOpenReplyMyCommentNotification(messageData);
            }
          }
        }
      },
    );
  }

  Future sendNewMessageNotification(
      String chatterId, String chatId, String message) async {
    List<String> userTokens =
        await _userDataController.getUserTokensById(chatterId);
    final body = {
      "registration_ids": userTokens,
      "notification": {
        "title": currentUserName,
        "body": message,
        "android_channel_id": "messages",
        "icon": "drawable/message_notificaion",
        "color": "#6b63ff",
      },
      "data": {
        "type": "chat",
        "chatter_id": currentUserId,
        "chatter_type": currentUserType.name,
        "chat_id": chatId,
      }
    };

    await post(
      Uri.parse(AppConstants.baseFCMUrl),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader:
            'key=${AppConstants.fcmAutherizationKey}'
      },
      body: jsonEncode(body),
    );
  }

  Future notifyDoctorsWithSameSearchingSpecialization(
      UserPostModel postModel) async {
    Map<String, dynamic> data = {
      'post_id': postModel.postId!,
      'specialization': postModel.searchingSpecialization,
      'is_ergent': postModel.isErgent,
    };
    List<String> userTokens =
        await _userDataController.getDoctorsTokensWithSearchingSpechialization(
      data,
      postModel.timeStamp!,
      currentUserId,
      currentUserName,
      currentUserGender,
      currentUserType,
    );
    if (userTokens.isNotEmpty) {
      final body = {
        "registration_ids": userTokens,
        "notification": {
          "title": postModel.isErgent ? 'حالة طارئة !!' : 'سؤال',
          "body":
              '$currentUserName ${(currentUserGender == Gender.male) ? 'يبحث عن' : 'تبحث عن'} ${postModel.searchingSpecialization}',
          "android_channel_id": "timeLine",
          "icon":
              postModel.isErgent ? "drawable/emergency" : "drawable/logo_white",
          "color": postModel.isErgent ? "#ff0000" : "#6b63ff",
        },
        "data": {
          "type": "patient_question",
          "is_ergent": postModel.isErgent,
          "post_id": postModel.postId,
          "writer_name": currentUserName,
          "writer_gender": currentUserGender.name,
          "specialization": postModel.searchingSpecialization,
        }
      };

      await post(
        Uri.parse(AppConstants.baseFCMUrl),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'key=${AppConstants.fcmAutherizationKey}'
        },
        body: jsonEncode(body),
      );
    }
  }

  Future notifyReact({
    required String writerId,
    required String reactedComponent,
    required String postId,
    String? commentId,
    String? replyId,
  }) async {
    int reacts = 0;
    switch (reactedComponent) {
      case 'منشورك':
        NotificationModel notification = NotificationModel(
          id: const Uuid().v4(),
          type: NotificationType.reactMyPost,
          time: Timestamp.now(),
          data: {
            'post_id': postId,
          },
          notifierId: currentUserId,
          notifierName: currentUserName,
          notifierGender: currentUserGender,
          notifierType: currentUserType,
        );
        _userDataController.uploadNotification(notification, writerId);
        await _userDataController.getAllUsersPostsCollection
            .doc(postId)
            .get()
            .then(
          (value) {
            reacts = value['reacts'];
          },
        );
        break;
      case 'تعليقك':
        NotificationModel notification = NotificationModel(
          id: const Uuid().v4(),
          type: NotificationType.reactMyComment,
          time: Timestamp.now(),
          data: {
            'post_id': postId,
            'comment_id': commentId,
          },
          notifierId: currentUserId,
          notifierName: currentUserName,
          notifierGender: currentUserGender,
          notifierType: currentUserType,
        );
        _userDataController.uploadNotification(notification, writerId);
        await _userDataController
            .getCommentDocumentById(postId, commentId!)
            .get()
            .then(
          (value) {
            reacts = value['reacts'];
          },
        );
        break;
      case 'ردك':
        NotificationModel notification = NotificationModel(
          id: const Uuid().v4(),
          type: NotificationType.reactMyReply,
          time: Timestamp.now(),
          data: {
            'post_id': postId,
            'comment_id': commentId,
            'reply_id': replyId,
          },
          notifierId: currentUserId,
          notifierName: currentUserName,
          notifierGender: currentUserGender,
          notifierType: currentUserType,
        );
        _userDataController.uploadNotification(notification, writerId);
        await _userDataController
            .getReplyDocumentById(commentId!, replyId!)
            .get()
            .then(
          (value) {
            reacts = value['reacts'];
          },
        );
        break;
    }
    if (reacts < 5) {
      List<String> userTokens =
          await _userDataController.getUserTokensById(writerId);
      if (userTokens.isNotEmpty) {
        String notificationSubType = (reactedComponent == 'منشورك')
            ? "react_my_post"
            : (reactedComponent == 'تعليقك')
                ? "react_my_comment"
                : "react_my_reply";

        String title =
            ' ${(currentUserGender == Gender.male) ? 'قام' : 'قامت'} ${(currentUserType == UserType.doctor) ? (currentUserGender == Gender.male) ? 'الطبيب' : 'الطبيبة' : ''} $currentUserName بالتفاعل مع $reactedComponent';
        final body = {
          "registration_ids": userTokens,
          "notification": {
            "title": title,
            "android_channel_id": "timeLine",
            "color": "#6b63ff",
          },
          "data": {
            "type": "timeLine",
            "sub_type": notificationSubType,
            "post_id": postId,
            "comment_id": commentId,
            "reply_id": replyId,
          }
        };

        await post(
          Uri.parse(AppConstants.baseFCMUrl),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'key=${AppConstants.fcmAutherizationKey}'
          },
          body: jsonEncode(body),
        );
      }
    }
  }

  Future notifyComment({
    required String postWriterId,
    required String commentedComponent,
    required String postId,
    required String commentId,
    String? commentWriterId,
    String? replyId,
  }) async {
    int comments = 0;
    switch (commentedComponent) {
      case 'comment':
        NotificationModel notification = NotificationModel(
          id: const Uuid().v4(),
          type: NotificationType.commentMyPost,
          time: Timestamp.now(),
          data: {
            'post_id': postId,
            'comment_id': commentId,
          },
          notifierId: currentUserId,
          notifierName: currentUserName,
          notifierGender: currentUserGender,
          notifierType: currentUserType,
        );
        if (currentUserId != postWriterId) {
          _userDataController.uploadNotification(notification, postWriterId);
        }

        _notifyOtherCommenters(postId, commentId, postWriterId);
        comments = await _userDataController
            .getPostCommentsCollectionById(postId)
            .count()
            .get()
            .then((value) => value.count);
        break;
      case 'reply':
        NotificationModel notification = NotificationModel(
          id: const Uuid().v4(),
          type: NotificationType.replyMyComment,
          time: Timestamp.now(),
          data: {
            'post_id': postId,
            'comment_id': commentId,
            'reply_id': replyId,
          },
          notifierId: currentUserId,
          notifierName: currentUserName,
          notifierGender: currentUserGender,
          notifierType: currentUserType,
        );
        if (currentUserId != commentWriterId) {
          _userDataController.uploadNotification(
              notification, commentWriterId!);
        }
        _notifyOtherRepliers(
          postId,
          commentId,
          replyId!,
          postWriterId,
          commentWriterId!,
        );
        if (currentUserId != postWriterId && postWriterId != commentWriterId) {
          _notifyPostWriterOfReply(
            postId,
            commentId,
            replyId,
            postWriterId,
          );
        }
        comments = await _userDataController
            .getCommentRepliesCollectionById(commentId)
            .count()
            .get()
            .then((value) => value.count);
        break;
      default:
    }
    if ((commentedComponent == 'reply' && commentWriterId != currentUserId) ||
        (commentedComponent == 'comment' && postWriterId != currentUserId)) {
      List<String> userTokens = await _userDataController.getUserTokensById(
          (commentedComponent == 'comment') ? postWriterId : commentWriterId!);
      if (userTokens.isNotEmpty && comments < 5) {
        String title =
            ' ${(currentUserGender == Gender.male) ? 'قام' : 'قامت'} ${(currentUserType == UserType.doctor) ? (currentUserGender == Gender.male) ? 'الطبيب' : 'الطبيبة' : ''} $currentUserName ${(commentedComponent == 'comment') ? 'بالتعليق على منشورك' : 'بالرد على تعليقك'} ';

        final body = {
          "registration_ids": userTokens,
          "notification": {
            "title": title,
            "android_channel_id": "timeLine",
            "color": "#6b63ff",
          },
          "data": {
            "type": "timeLine",
            "sub_type": (commentedComponent == 'comment')
                ? "comment_my_post"
                : "reply_my_comment",
            "post_id": postId,
            "comment_id": commentId,
            "reply_id": replyId,
          }
        };

        await post(
          Uri.parse(AppConstants.baseFCMUrl),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'key=${AppConstants.fcmAutherizationKey}'
          },
          body: jsonEncode(body),
        );
      }
    }
  }

  notifyFollowingDoctorPost(DoctorPostModel post) async {
    NotificationType notificationType;
    switch (post.postType) {
      case DoctorPostType.medicalInfo:
        notificationType = NotificationType.followedDoctorMedicalInfoPost;
        break;
      case DoctorPostType.newClinic:
        notificationType = NotificationType.followedDoctorNewClinicPost;
        break;
      case DoctorPostType.discount:
        notificationType = NotificationType.followedDoctorDiscountPost;
        break;
      case DoctorPostType.other:
        notificationType = NotificationType.followedDoctorPost;
        break;
    }
    NotificationModel notification = NotificationModel(
      id: const Uuid().v4(),
      type: notificationType,
      time: post.timeStamp!,
      data: {
        'post_id': post.postId,
      },
      notifierId: currentUserId,
      notifierName: currentUserName,
      notifierGender: currentUserGender,
      notifierType: currentUserType,
    );
    _notifyFollowers(notification);
  }

  Future _notifyOtherCommenters(
    String postId,
    String commentId,
    String postWriterId,
  ) async {
    _userDataController
        .getPostCommentsCollectionById(postId)
        .where('uid', whereNotIn: [currentUserId, postWriterId])
        .get()
        .then(
          (snapshot) async {
            NotificationModel notification = NotificationModel(
              id: const Uuid().v4(),
              type: NotificationType.commentOnPostICommented,
              time: Timestamp.now(),
              data: {
                'post_id': postId,
                'comment_id': commentId,
              },
              notifierId: currentUserId,
              notifierName: currentUserName,
              notifierGender: currentUserGender,
              notifierType: currentUserType,
            );
            for (var user in snapshot.docs) {
              _userDataController.uploadNotification(
                notification,
                user.get('uid'),
              );
            }
          },
        );
  }

  Future _notifyOtherRepliers(
    String postId,
    String commentId,
    String replyId,
    String postWriterId,
    String commentWriterId,
  ) async {
    _userDataController
        .getCommentRepliesCollectionById(commentId)
        .where('uid',
            whereNotIn: [currentUserId, commentWriterId, postWriterId])
        .get()
        .then(
          (snapshot) async {
            NotificationModel notification = NotificationModel(
              id: const Uuid().v4(),
              type: NotificationType.replyOnCommentIReplied,
              time: Timestamp.now(),
              data: {
                'post_id': postId,
                'comment_id': commentId,
                'reply_id': replyId,
              },
              notifierId: currentUserId,
              notifierName: currentUserName,
              notifierGender: currentUserGender,
              notifierType: currentUserType,
            );
            for (var user in snapshot.docs) {
              _userDataController.uploadNotification(
                notification,
                user.get('uid'),
              );
            }
          },
        );
  }

  _notifyPostWriterOfReply(
    String postId,
    String commentId,
    String replyId,
    String postWriterId,
  ) {
    NotificationModel notification = NotificationModel(
      id: const Uuid().v4(),
      type: NotificationType.replyOnMyPost,
      time: Timestamp.now(),
      data: {
        'post_id': postId,
        'comment_id': commentId,
        'reply_id': replyId,
      },
      notifierId: currentUserId,
      notifierName: currentUserName,
      notifierGender: currentUserGender,
      notifierType: currentUserType,
    );
    _userDataController.uploadNotification(notification, postWriterId);
  }

  _notifyFollowers(NotificationModel notification) {
    _userDataController
        .getDoctorFollowersCollectionById(currentUserId)
        .get()
        .then(
      (snapshot) async {
        for (var follower in snapshot.docs) {
          await _userDataController.uploadNotification(
              notification, follower.id);
        }
      },
    );
  }

  /*-----------------------------------------------------------------------------
  -                          Foreground Notifiers                              -
  ------------------------------------------------------------------------------*/

  _foregroundNotifyNewMessage(Map<String, dynamic> messageData) {
    if (!Get.isRegistered<SingleChatPageController>(
        tag: messageData['chatter_id'])) {
      bool pressed = false;
      Get.showSnackbar(
        GetSnackBar(
          messageText: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'ارسل ${messageData['chatter_name']} رسالة جديدة',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: AppFonts.mainArabicFontFamily,
                fontSize: 18,
              ),
            ),
          ),
          mainButton: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ElevatedButton(
              onPressed: () {
                if (!pressed) {
                  pressed = true;
                  _onOpenNewMessageNotification(messageData);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
              ),
              child: const Text(
                'فتح',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontFamily: AppFonts.mainArabicFontFamily,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  shadows: [
                    BoxShadow(
                      color: Colors.black38,
                      spreadRadius: 0.3,
                      blurRadius: 0.2,
                      offset: Offset(0, 0.3),
                    ),
                  ],
                ),
              ),
            ),
          ),
          backgroundColor: AppColors.primaryColor,
          snackPosition: SnackPosition.TOP,
          snackStyle: SnackStyle.GROUNDED,
          duration: const Duration(milliseconds: 3000),
          animationDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  _foregroundNotifyErgentCase(Map<String, dynamic> messageData) {
    bool pressed = false;
    Get.showSnackbar(
      GetSnackBar(
        messageText: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'حالة طارئة ! \n${messageData['writer_name']} ${(messageData['writer_gender'] == 'male') ? 'يبحث عن' : 'تبحث عن'} ${messageData['specialization']}',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: AppFonts.mainArabicFontFamily,
              fontSize: 18,
            ),
          ),
        ),
        mainButton: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ElevatedButton(
            onPressed: () async {
              if (!pressed) {
                pressed = true;
                _onOpenPatientQuestionNotification(messageData);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 5,
            ),
            child: const Text(
              'فتح',
              style: TextStyle(
                color: Colors.red,
                fontFamily: AppFonts.mainArabicFontFamily,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                shadows: [
                  BoxShadow(
                    color: Colors.black38,
                    spreadRadius: 0.3,
                    blurRadius: 0.2,
                    offset: Offset(0, 0.3),
                  ),
                ],
              ),
            ),
          ),
        ),
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.TOP,
        snackStyle: SnackStyle.GROUNDED,
        duration: const Duration(milliseconds: 3000),
        animationDuration: const Duration(milliseconds: 600),
      ),
    );
  }

//------------------------------------------------------------------------------

/*-----------------------------------------------------------------------------
-                       background on Notification opened                     -
------------------------------------------------------------------------------*/

  _onOpenNewMessageNotification(Map<String, dynamic> messageData) {
    Get.to(
      () => SingleChatPage(
        chatterId: messageData['chatter_id'],
        chatterType: messageData['chatter_type'] == 'user'
            ? UserType.user
            : UserType.doctor,
        chatId: messageData['chat_id'],
      ),
    );
  }

  _onOpenPatientQuestionNotification(Map<String, dynamic> messageData) async {
    UserPostModel? post =
        await _userDataController.getUserPostById(messageData['post_id']);
    if (post == null) {
      CommonFunctions.deletedElement();
    } else {
      Get.to(
        () => PostPage(post: post, writerType: UserType.user),
      );
    }
  }

  _onOpenReactMyPostNotification(Map<String, dynamic> messageData) async {
    ParentPostModel? post;
    if (currentUserType == UserType.doctor) {
      post = await _userDataController.getDoctorPostById(
          messageData['post_id'], currentUser as DoctorModel);
    } else {
      post = await _userDataController.getUserPostById(
          messageData['post_id'], currentUser as UserModel);
    }
    if (post == null) {
      CommonFunctions.deletedElement();
    } else {
      Get.to(
        () => PostPage(post: post!, writerType: currentUserType),
      );
    }
  }

  _onOpenReactMyCommentNotification(Map<String, dynamic> messageData) async {
    ParentPostModel? post =
        await _userDataController.getPostById(messageData['post_id']);
    if (post == null) {
      CommonFunctions.deletedElement();
    } else {
      CommentModel? comment = await _userDataController.getCommentById(
        messageData['post_id'],
        messageData['comment_id'],
        currentUser,
      );
      Get.to(
        () => PostPage(post: post, writerType: post.writerType!),
      );
      await Future.delayed(const Duration(milliseconds: 700));
      if (comment == null) {
        CommonFunctions.deletedElement();
      } else {
        Get.to(
          () => CommentPage(
            comment: comment,
            postWriterId: (post.writerType == UserType.user)
                ? (post as UserPostModel).user.userId!
                : (post as DoctorPostModel).writer!.userId!,
          ),
        );
      }
    }
  }

  _onOpenReactMyReplyNotification(Map<String, dynamic> messageData) async {
    ParentPostModel? post =
        await _userDataController.getPostById(messageData['post_id']);
    if (post == null) {
      CommonFunctions.deletedElement();
    } else {
      CommentModel? comment = await _userDataController.getCommentById(
        messageData['post_id'],
        messageData['comment_id'],
      );
      if (comment == null) {
        Get.to(
          () => PostPage(post: post, writerType: post.writerType!),
        );
        await Future.delayed(const Duration(milliseconds: 700));
        CommonFunctions.deletedElement();
      } else {
        ReplyModel? reply = await _userDataController.getReplyById(
          messageData['comment_id'],
          messageData['reply_id'],
          currentUser,
        );

        Get.to(
          () => PostPage(post: post, writerType: post.writerType!),
        );
        await Future.delayed(const Duration(milliseconds: 700));

        Get.to(
          () => CommentPage(
            comment: comment,
            postWriterId: (post.writerType == UserType.user)
                ? (post as UserPostModel).user.userId!
                : (post as DoctorPostModel).writer!.userId!,
          ),
        );
        await Future.delayed(const Duration(milliseconds: 700));
        if (reply == null) {
          CommonFunctions.deletedElement();
        } else {
          Get.to(() => ReplyPage(reply: reply));
        }
      }
    }
  }

  _onOpenCommentMyPostNotification(Map<String, dynamic> messageData) async {
    ParentPostModel? post;
    if (currentUserType == UserType.doctor) {
      post = await _userDataController.getDoctorPostById(
          messageData['post_id'], currentUser as DoctorModel);
    } else {
      post = await _userDataController.getUserPostById(
          messageData['post_id'], currentUser as UserModel);
    }
    if (post == null) {
      CommonFunctions.deletedElement();
    } else {
      CommentModel? comment = await _userDataController.getCommentById(
        messageData['post_id'],
        messageData['comment_id'],
      );
      Get.to(
        () => PostPage(post: post!, writerType: post.writerType!),
      );
      await Future.delayed(const Duration(milliseconds: 700));
      if (comment == null) {
        CommonFunctions.deletedElement();
      } else {
        Get.to(
          () => CommentPage(
            comment: comment,
            postWriterId: (post!.writerType == UserType.user)
                ? (post as UserPostModel).user.userId!
                : (post as DoctorPostModel).writer!.userId!,
          ),
        );
      }
    }
  }

  _onOpenReplyMyCommentNotification(Map<String, dynamic> messageData) async {
    ParentPostModel? post =
        await _userDataController.getPostById(messageData['post_id']);
    if (post == null) {
      CommonFunctions.deletedElement();
    } else {
      CommentModel? comment = await _userDataController.getCommentById(
        messageData['post_id'],
        messageData['comment_id'],
        currentUser,
      );
      if (comment == null) {
        Get.to(
          () => PostPage(post: post, writerType: post.writerType!),
        );
        await Future.delayed(const Duration(milliseconds: 700));
        CommonFunctions.deletedElement();
      } else {
        ReplyModel? reply = await _userDataController.getReplyById(
          messageData['comment_id'],
          messageData['reply_id'],
        );
        Get.to(
          () => PostPage(post: post, writerType: post.writerType!),
        );
        await Future.delayed(const Duration(milliseconds: 700));
        Get.to(
          () => CommentPage(
            comment: comment,
            postWriterId: (post.writerType == UserType.user)
                ? (post as UserPostModel).user.userId!
                : (post as DoctorPostModel).writer!.userId!,
          ),
        );
        await Future.delayed(const Duration(milliseconds: 700));
        if (reply == null) {
          CommonFunctions.deletedElement();
        } else {
          Get.to(() => ReplyPage(reply: reply));
        }
      }
    }
  }
//------------------------------------------------------------------------------

  String? get currentToken => _token;
  ParentUserModel get currentUser => _authenticationController.currentUser;
  UserType get currentUserType => _authenticationController.currentUserType;
  String get currentUserId => _authenticationController.currentUserId;
  String get currentUserName => _authenticationController.currentUserName;
  String? get currentUserPersonalImage =>
      _authenticationController.currentUserPersonalImage;
  Gender get currentUserGender => _authenticationController.currentUserGender;
  get currentUserBirthDate => _authenticationController.currentUserBirthDate;
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  if (message.data['type'] == 'timeLine' ||
      message.data['type'] == 'patient_question') {
    if (Get.isRegistered<MainPageController>()) {
      MainPageController.find.newNotifications.value = true;
    }
  }
}
