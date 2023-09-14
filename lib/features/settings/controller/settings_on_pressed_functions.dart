import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/features/settings/Pages/account_data/account_data_page.dart';
import 'package:clinic/features/settings/Pages/account_data/change_degree_page.dart';
import 'package:clinic/features/settings/Pages/account_data/change_password_page.dart';
import 'package:clinic/features/settings/Pages/activities_history/activities_history_page.dart';
import 'package:clinic/features/settings/model/comment_activity_model.dart';
import 'package:clinic/features/settings/model/post_activity_model.dart';
import 'package:clinic/features/settings/model/reply_activity_model.dart';
import 'package:clinic/features/time_line/model/comment_model.dart';
import 'package:clinic/features/time_line/model/doctor_post_model.dart';
import 'package:clinic/features/time_line/model/parent_post_model.dart';
import 'package:clinic/features/time_line/model/reply_model.dart';
import 'package:clinic/features/time_line/model/user_post_model.dart';
import 'package:clinic/features/time_line/pages/post/comment/comment_page.dart';
import 'package:clinic/features/time_line/pages/post/comment/reply_page.dart';
import 'package:clinic/features/time_line/pages/post/common/post_page.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/data/models/doctor_model.dart';
import 'package:clinic/global/data/models/parent_user_model.dart';
import 'package:clinic/global/data/models/user_model.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsOnPressedFunctions {
  ///------------------------------ account data -------------------------------
  static void onAccountDataSettingPressed() {
    Get.to(
      () => const AccountDataPage(),
      transition: Transition.rightToLeftWithFade,
    );
  }

  static void onChangePasswordSettingPressed() {
    Get.to(
      () => const ChangePasswordPage(),
      transition: Transition.rightToLeftWithFade,
    );
  }

  static void onChangeDegreeSettingPressed() {
    Get.to(
      () => const ChangeDegreePage(),
      transition: Transition.rightToLeftWithFade,
    );
  }

  ///------------------------------ ------------ -------------------------------

  ///--------------------------- activities history ----------------------------
  static void onActivitiesHistorySettingPressed() {
    Get.to(
      () => const ActivitiesHistoryPage(),
      transition: Transition.rightToLeftWithFade,
    );
  }

  static Future onLikedPostActivityPressed(
      PostActivityModel activityModel) async {
    ParentPostModel? post;
    if (currentUserId == activityModel.postWriterId) {
      if (currentUserType == UserType.doctor) {
        post = await UserDataController.find.getDoctorPostById(
            currentUserId, activityModel.postId, currentUser as DoctorModel);
      } else {
        post = await UserDataController.find.getUserPostById(
            currentUserId, activityModel.postId, currentUser as UserModel);
      }
    } else {
      post = await UserDataController.find
          .getPostById(currentUserId, activityModel.postId);
    }
    Get.back();
    if (post == null) {
      CommonFunctions.deletedElement();
    } else {
      Get.to(
        () => PostPage(post: post!, writerType: activityModel.postWriterType),
        transition: Transition.rightToLeftWithFade,
      );
    }
  }

  static Future onCommentPostActivityPressed(
      PostActivityModel activityModel) async {
    ParentPostModel? post;
    if (currentUserId == activityModel.postWriterId) {
      if (currentUserType == UserType.doctor) {
        post = await UserDataController.find.getDoctorPostById(
            currentUserId, activityModel.postId, currentUser as DoctorModel);
      } else {
        post = await UserDataController.find.getUserPostById(
            currentUserId, activityModel.postId, currentUser as UserModel);
      }
    } else {
      post = await UserDataController.find
          .getPostById(currentUserId, activityModel.postId);
    }
    if (post == null) {
      Get.back();
      CommonFunctions.deletedElement();
    } else {
      CommentModel? comment = await UserDataController.find.getCommentById(
        currentUserId,
        activityModel.postId,
        activityModel.id!,
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
            postWriterId: activityModel.postWriterId,
          ),
          transition: Transition.rightToLeftWithFade,
        );
      }
    }
  }

  static Future onLikedCommentActivityPressed(
      CommentActivityModel activityModel) async {
    ParentPostModel? post;
    post = await UserDataController.find
        .getPostById(currentUserId, activityModel.postId);
    if (post == null) {
      Get.back();
      CommonFunctions.deletedElement();
    } else {
      CommentModel? comment = await UserDataController.find.getCommentById(
        currentUserId,
        activityModel.postId,
        activityModel.commentId,
        (currentUserId == activityModel.commentWriterId) ? currentUser : null,
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
                : (post as DoctorPostModel).writer!.userId!,
          ),
          transition: Transition.rightToLeftWithFade,
        );
      }
    }
  }

  static Future onReplyCommentActivityPressed(
      CommentActivityModel activityModel) async {
    ParentPostModel? post;
    if (currentUserId == activityModel.postWriterId) {
      if (currentUserType == UserType.doctor) {
        post = await UserDataController.find.getDoctorPostById(
            currentUserId, activityModel.postId, currentUser as DoctorModel);
      } else {
        post = await UserDataController.find.getUserPostById(
            currentUserId, activityModel.postId, currentUser as UserModel);
      }
    } else {
      post = await UserDataController.find
          .getPostById(currentUserId, activityModel.postId);
    }
    if (post == null) {
      Get.back();
      CommonFunctions.deletedElement();
    } else {
      CommentModel? comment = await UserDataController.find.getCommentById(
        currentUserId,
        activityModel.postId,
        activityModel.commentId,
        (currentUserId == activityModel.commentWriterId) ? currentUser : null,
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
          activityModel.commentId,
          activityModel.id!,
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
                : (post as DoctorPostModel).writer!.userId!,
          ),
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

  static Future onLikedReplyActivityPressed(
      ReplyActivityModel activityModel) async {
    ParentPostModel? post;
    post = await UserDataController.find
        .getPostById(currentUserId, activityModel.postId);
    if (post == null) {
      Get.back();
      CommonFunctions.deletedElement();
    } else {
      CommentModel? comment = await UserDataController.find.getCommentById(
        currentUserId,
        activityModel.postId,
        activityModel.commentId,
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
          activityModel.commentId,
          activityModel.replyId,
          (currentUserId == activityModel.replyWriterId) ? currentUser : null,
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
                : (post as DoctorPostModel).writer!.userId!,
          ),
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

  ///--------------------------- ------------------ ----------------------------

  ///------------------------------- contact us --------------------------------
  static void onContactUsSettingPressed(BuildContext context) async {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailUrl = Uri(
      scheme: 'mailto',
      path: AppConstants.tabibGroupMail,
      query: encodeQueryParameters({
        'subject': 'الموضوع',
        'body': 'اكتب رسالتك',
      }),
    );
    if (await canLaunchUrl(emailUrl)) {
      launchUrl(emailUrl);
    } else {
      CommonFunctions.errorHappened();
    }
  }

  ///------------------------------- ---------- --------------------------------

  ///--------------------------------- signout ---------------------------------
  static void onSingOutSettingPressed(BuildContext context) {
    MyAlertDialog.showAlertDialog(
      context,
      'تسجيل الخروج',
      'هل انت متأكد من تسجيل الخروج؟',
      MyAlertDialog.getAlertDialogActions(
        {
          'نعم': () async {
            try {
              AuthenticationController.find.logout(true);
            } catch (e) {
              Get.back();
              CommonFunctions.errorHappened();
            }
          },
          'إلغاء': () => Get.back(),
        },
      ),
    );
  }

  ///--------------------------------- ------- ---------------------------------
  static ParentUserModel get currentUser =>
      AuthenticationController.find.currentUser;
  static UserType get currentUserType =>
      AuthenticationController.find.currentUserType;
  static String get currentUserId =>
      AuthenticationController.find.currentUserId;
}
