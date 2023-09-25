import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/features/doctor_profile/pages/doctor_profile_page.dart';
import 'package:clinic/features/notifications/model/notification_model.dart';
import 'package:clinic/features/time_line/model/comment_model.dart';
import 'package:clinic/features/time_line/model/doctor_post_model.dart';
import 'package:clinic/features/time_line/model/parent_post_model.dart';
import 'package:clinic/features/time_line/model/reply_model.dart';
import 'package:clinic/features/time_line/model/user_post_model.dart';
import 'package:clinic/features/time_line/pages/post/comment/comment_page.dart';
import 'package:clinic/features/time_line/pages/post/comment/reply_page.dart';
import 'package:clinic/features/time_line/pages/post/common/post_page.dart';
import 'package:clinic/features/user_profile/pages/user_profile_page.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/data/models/doctor_model.dart';
import 'package:clinic/global/data/models/parent_user_model.dart';
import 'package:clinic/global/data/models/user_model.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:get/get.dart';

class NotificationsOnPressedFunctions {
  static void newFollowNotificationOnPressed(NotificationModel notification) {
    Get.back();
    if (notification.notifierType == UserType.doctor) {
      Get.to(
        () => DoctorProfilePage(
            doctorId: notification.notifierId, isCurrentUser: false),
        transition: Transition.rightToLeftWithFade,
      );
    } else {
      Get.to(
        () => UserProfilePage(userId: notification.notifierId),
        transition: Transition.rightToLeftWithFade,
      );
    }
  }

  static Future reactMyPostNotificationOnPressed(
      NotificationModel notification) async {
    ParentPostModel? post;
    if (currentUserType == UserType.doctor) {
      post = await UserDataController.find.getDoctorPostById(currentUserId,
          notification.data['post_id'], currentUser as DoctorModel);
    } else {
      post = await UserDataController.find.getUserPostById(currentUserId,
          notification.data['post_id'], currentUser as UserModel);
    }
    Get.back();
    if (post == null) {
      CommonFunctions.deletedElement();
    } else {
      Get.to(
        () => PostPage(post: post!, writerType: currentUserType),
        transition: Transition.rightToLeftWithFade,
      );
    }
  }

  static Future reactMyCommentNotificationOnPressed(
      NotificationModel notification) async {
    ParentPostModel? post;
    post = await UserDataController.find
        .getPostById(currentUserId, notification.data['post_id']);
    if (post == null) {
      Get.back();
      CommonFunctions.deletedElement();
    } else {
      CommentModel? comment = await UserDataController.find.getCommentById(
        currentUserId,
        notification.data['post_id'],
        notification.data['comment_id'],
        currentUser,
      );
      Get.back();
      Get.to(
        () => PostPage(post: post!, writerType: post.writerType!),
        transition: Transition.rightToLeftWithFade,
      );
      await Future.delayed(const Duration(milliseconds: 400));
      if (comment == null) {
        CommonFunctions.deletedElement();
      } else {
        Get.to(
          () => CommentPage(
              postWriterType: post!.writerType!,
              comment: comment,
              postWriterId: (post.writerType == UserType.user)
                  ? (post as UserPostModel).user.userId!
                  : (post as DoctorPostModel).writer!.userId!),
          transition: Transition.rightToLeftWithFade,
        );
      }
    }
  }

  static Future reactMyReplyNotificationOnPressed(
      NotificationModel notification) async {
    ParentPostModel? post;
    post = await UserDataController.find
        .getPostById(currentUserId, notification.data['post_id']);

    if (post == null) {
      Get.back();
      CommonFunctions.deletedElement();
    } else {
      CommentModel? comment = await UserDataController.find.getCommentById(
        currentUserId,
        notification.data['post_id'],
        notification.data['comment_id'],
      );
      if (comment == null) {
        Get.back();
        Get.to(
          () => PostPage(post: post!, writerType: post.writerType!),
          transition: Transition.rightToLeftWithFade,
        );
        await Future.delayed(const Duration(milliseconds: 400));
        CommonFunctions.deletedElement();
      } else {
        ReplyModel? reply = await UserDataController.find.getReplyById(
          currentUserId,
          notification.data['comment_id'],
          notification.data['reply_id'],
          currentUser,
        );

        Get.back();
        Get.to(
          () => PostPage(post: post!, writerType: post.writerType!),
          transition: Transition.rightToLeftWithFade,
        );
        await Future.delayed(const Duration(milliseconds: 400));
        Get.to(
          () => CommentPage(
              postWriterType: post!.writerType!,
              comment: comment,
              postWriterId: (post.writerType == UserType.user)
                  ? (post as UserPostModel).user.userId!
                  : (post as DoctorPostModel).writer!.userId!),
          transition: Transition.rightToLeftWithFade,
        );
        await Future.delayed(const Duration(milliseconds: 400));
        if (reply == null) {
          CommonFunctions.deletedElement();
        } else {
          Get.to(
            () => ReplyPage(reply: reply),
            transition: Transition.rightToLeftWithFade,
          );
        }
      }
    }
  }

  static Future commentMyPostNotificationOnPressed(
      NotificationModel notification) async {
    ParentPostModel? post;
    if (currentUserType == UserType.doctor) {
      post = await UserDataController.find.getDoctorPostById(currentUserId,
          notification.data['post_id'], currentUser as DoctorModel);
    } else {
      post = await UserDataController.find.getUserPostById(currentUserId,
          notification.data['post_id'], currentUser as UserModel);
    }
    if (post == null) {
      Get.back();
      CommonFunctions.deletedElement();
    } else {
      CommentModel? comment = await UserDataController.find.getCommentById(
        currentUserId,
        notification.data['post_id'],
        notification.data['comment_id'],
      );
      Get.back();
      Get.to(
        () => PostPage(post: post!, writerType: post.writerType!),
        transition: Transition.rightToLeftWithFade,
      );
      await Future.delayed(const Duration(milliseconds: 400));
      if (comment == null) {
        CommonFunctions.deletedElement();
      } else {
        Get.to(
          CommentPage(
              postWriterType: post.writerType!,
              comment: comment,
              postWriterId: (post.writerType == UserType.user)
                  ? (post as UserPostModel).user.userId!
                  : (post as DoctorPostModel).writer!.userId!),
          transition: Transition.rightToLeftWithFade,
        );
      }
    }
  }

  static Future commentOnPostICommentedNotificationOnPressed(
      NotificationModel notification) async {
    ParentPostModel? post = await UserDataController.find
        .getPostById(currentUserId, notification.data['post_id']);
    if (post == null) {
      Get.back();
      CommonFunctions.deletedElement();
    } else {
      CommentModel? comment = await UserDataController.find.getCommentById(
        currentUserId,
        notification.data['post_id'],
        notification.data['comment_id'],
      );
      Get.back();
      Get.to(
        () => PostPage(post: post, writerType: post.writerType!),
        transition: Transition.rightToLeftWithFade,
      );
      await Future.delayed(const Duration(milliseconds: 400));
      if (comment == null) {
        CommonFunctions.deletedElement();
      } else {
        Get.to(
          CommentPage(
              postWriterType: post.writerType!,
              comment: comment,
              postWriterId: (post.writerType == UserType.user)
                  ? (post as UserPostModel).user.userId!
                  : (post as DoctorPostModel).writer!.userId!),
          transition: Transition.rightToLeftWithFade,
        );
      }
    }
  }

  static Future replyMyCommentNotificationOnPressed(
      NotificationModel notification) async {
    ParentPostModel? post = await UserDataController.find
        .getPostById(currentUserId, notification.data['post_id']);

    if (post == null) {
      Get.back();
      CommonFunctions.deletedElement();
    } else {
      CommentModel? comment = await UserDataController.find.getCommentById(
        currentUserId,
        notification.data['post_id'],
        notification.data['comment_id'],
        currentUser,
      );

      if (comment == null) {
        Get.back();
        Get.to(
          () => PostPage(post: post, writerType: post.writerType!),
          transition: Transition.rightToLeftWithFade,
        );
        await Future.delayed(const Duration(milliseconds: 400));
        CommonFunctions.deletedElement();
      } else {
        ReplyModel? reply = await UserDataController.find.getReplyById(
          currentUserId,
          notification.data['comment_id'],
          notification.data['reply_id'],
        );
        Get.back();
        Get.to(
          () => PostPage(post: post, writerType: post.writerType!),
          transition: Transition.rightToLeftWithFade,
        );
        await Future.delayed(const Duration(milliseconds: 400));
        Get.to(
          CommentPage(
              postWriterType: post.writerType!,
              comment: comment,
              postWriterId: (post.writerType == UserType.user)
                  ? (post as UserPostModel).user.userId!
                  : (post as DoctorPostModel).writer!.userId!),
          transition: Transition.rightToLeftWithFade,
        );
        await Future.delayed(const Duration(milliseconds: 400));
        if (reply == null) {
          CommonFunctions.deletedElement();
        } else {
          Get.to(
            () => ReplyPage(reply: reply),
            transition: Transition.rightToLeftWithFade,
          );
        }
      }
    }
  }

  static Future replyOnMyPostNotificationOnPressed(
      NotificationModel notification) async {
    ParentPostModel? post;
    if (currentUserType == UserType.doctor) {
      post = await UserDataController.find.getDoctorPostById(currentUserId,
          notification.data['post_id'], currentUser as DoctorModel);
    } else {
      post = await UserDataController.find.getUserPostById(currentUserId,
          notification.data['post_id'], currentUser as UserModel);
    }
    if (post == null) {
      Get.back();
      CommonFunctions.deletedElement();
    } else {
      CommentModel? comment = await UserDataController.find.getCommentById(
        currentUserId,
        notification.data['post_id'],
        notification.data['comment_id'],
      );
      if (comment == null) {
        Get.back();
        Get.to(
          () => PostPage(
            post: post!,
            writerType: post.writerType!,
          ),
          transition: Transition.rightToLeftWithFade,
        );
        await Future.delayed(const Duration(milliseconds: 400));
        CommonFunctions.deletedElement();
      } else {
        ReplyModel? reply = await UserDataController.find.getReplyById(
          currentUserId,
          notification.data['comment_id'],
          notification.data['reply_id'],
        );

        Get.back();
        Get.to(
          () => PostPage(post: post!, writerType: post.writerType!),
          transition: Transition.rightToLeftWithFade,
        );
        await Future.delayed(const Duration(milliseconds: 400));
        Get.to(
          () => CommentPage(
              postWriterType: post!.writerType!,
              comment: comment,
              postWriterId: (post.writerType == UserType.user)
                  ? (post as UserPostModel).user.userId!
                  : (post as DoctorPostModel).writer!.userId!),
          transition: Transition.rightToLeftWithFade,
        );
        await Future.delayed(const Duration(milliseconds: 400));
        if (reply == null) {
          CommonFunctions.deletedElement();
        } else {
          Get.to(
            () => ReplyPage(reply: reply),
            transition: Transition.rightToLeftWithFade,
          );
        }
      }
    }
  }

  static Future replyOnCommentIRepliedNotificationOnPressed(
      NotificationModel notification) async {
    ParentPostModel? post = await UserDataController.find
        .getPostById(currentUserId, notification.data['post_id']);
    if (post == null) {
      Get.back();
      CommonFunctions.deletedElement();
    } else {
      CommentModel? comment = await UserDataController.find.getCommentById(
        currentUserId,
        notification.data['post_id'],
        notification.data['comment_id'],
      );
      if (comment == null) {
        Get.back();
        Get.to(
          () => PostPage(post: post, writerType: post.writerType!),
          transition: Transition.rightToLeftWithFade,
        );
        await Future.delayed(const Duration(milliseconds: 400));
        CommonFunctions.deletedElement();
      } else {
        ReplyModel? reply = await UserDataController.find.getReplyById(
          currentUserId,
          notification.data['comment_id'],
          notification.data['reply_id'],
        );
        Get.back();
        Get.to(
          () => PostPage(post: post, writerType: post.writerType!),
          transition: Transition.rightToLeftWithFade,
        );
        await Future.delayed(const Duration(milliseconds: 400));
        Get.to(
          () => CommentPage(
              postWriterType: post.writerType!,
              comment: comment,
              postWriterId: (post.writerType == UserType.user)
                  ? (post as UserPostModel).user.userId!
                  : (post as DoctorPostModel).writer!.userId!),
          transition: Transition.rightToLeftWithFade,
        );
        await Future.delayed(const Duration(milliseconds: 400));
        if (reply == null) {
          CommonFunctions.deletedElement();
        } else {
          Get.to(
            () => ReplyPage(reply: reply),
            transition: Transition.rightToLeftWithFade,
          );
        }
      }
    }
  }

  static Future searchingForMySpecializationNotificationOnPressed(
      NotificationModel notification) async {
    UserPostModel? post = await UserDataController.find
        .getUserPostById(currentUserId, notification.data['post_id']);
    Get.back();
    if (post == null) {
      CommonFunctions.deletedElement();
    } else {
      Get.to(
        () => PostPage(post: post, writerType: UserType.user),
        transition: Transition.rightToLeftWithFade,
      );
    }
  }

  static Future followedDoctorPostNotificationOnPressed(
      NotificationModel notification) async {
    DoctorPostModel? post = await UserDataController.find
        .getDoctorPostById(currentUserId, notification.data['post_id']);

    Get.back();
    if (post == null) {
      CommonFunctions.deletedElement();
    } else {
      Get.to(
        () => PostPage(post: post, writerType: UserType.doctor),
        transition: Transition.rightToLeftWithFade,
      );
    }
  }

  static Future questionAllowenceNotificationOnPressed(
      NotificationModel notification) async {
    if (notification.data['allowed']) {
      UserPostModel? post = await UserDataController.find.getUserPostById(
          currentUserId,
          notification.data['post_id'],
          currentUser as UserModel);

      Get.back();
      if (post == null) {
        CommonFunctions.deletedElement();
      } else {
        Get.to(
          () => PostPage(post: post, writerType: currentUserType),
          transition: Transition.rightToLeftWithFade,
        );
      }
    }
  }

  static ParentUserModel get currentUser =>
      AuthenticationController.find.currentUser;
  static UserType get currentUserType =>
      AuthenticationController.find.currentUserType;
  static String get currentUserId =>
      AuthenticationController.find.currentUserId;
  static String get currentUserName =>
      AuthenticationController.find.currentUserName;
  static String? get currentUserPersonalImage =>
      AuthenticationController.find.currentUserPersonalImage;
}
