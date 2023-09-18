import 'package:clinic/features/chat/pages/message/message_time_widget.dart';
import 'package:clinic/features/settings/controller/activity_page_controller.dart';
import 'package:clinic/features/settings/model/activity.dart';
import 'package:clinic/features/settings/model/comment_activity_model.dart';
import 'package:clinic/features/settings/model/post_activity_model.dart';
import 'package:clinic/features/settings/model/reply_activity_model.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SingleActivityListTile extends StatelessWidget {
  const SingleActivityListTile({
    Key? key,
    required this.activity,
    this.activityModel,
  }) : super(key: key);
  final dynamic activityModel;
  final Activity activity;

  @override
  Widget build(BuildContext context) {
    Timestamp time = activityModel.activityTime;
    return ListTile(
      trailing: Image.asset(
        _getActivityImage,
        width: 45,
        height: 45,
      ),
      title: Align(
        alignment: Alignment.centerRight,
        child: Text(
          _getActivityText,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          style: TextStyle(
            color: CommonFunctions.isLightMode(context)
                ? AppColors.darkThemeBackgroundColor
                : Colors.white,
            fontFamily: AppFonts.mainArabicFontFamily,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
      ),
      leading: GetX<ActivityPageController>(
        tag: activity.name,
        builder: (controller) {
          if (controller.deleteFabOpen.isTrue) {
            return Checkbox(
              value: controller.deletedActivities.contains(_getActivityId),
              onChanged: (value) =>
                  controller.selectActivity(_getActivityId, value!),
              activeColor: Colors.red,
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CommonFunctions.isToday(time.toDate())
                  ? const Text(
                      'اليوم',
                      style: TextStyle(
                        fontFamily: AppFonts.mainArabicFontFamily,
                        fontSize: 9,
                      ),
                    )
                  : CommonFunctions.isYesterday(time.toDate())
                      ? const Text(
                          'أمس',
                          style: TextStyle(
                              fontFamily: AppFonts.mainArabicFontFamily,
                              fontSize: 9),
                        )
                      : Text(
                          time.toDate().toString().substring(0, 10),
                          style: const TextStyle(
                            fontFamily: AppFonts.mainArabicFontFamily,
                            fontSize: 9,
                          ),
                        ),
              MessageTimeWidget(messageTime: time),
            ],
          );
        },
      ),
      onTap: () => _onActivityPressed(context),
    );
  }

  String get _getActivityText {
    final controller = ActivityPageController.find(activity.name);
    switch (activity) {
      case Activity.likedPosts:
        PostActivityModel act = activityModel;
        return 'تفاعلت مع ${(act.postWriterId == controller.currentUserId) ? 'منشورك' : 'منشور ${(act.postWriterType == UserType.doctor) ? (act.postWriterGender == Gender.male) ? 'الطبيب ' : 'الطبيبة ' : ''}${act.postWriterName}'}';
      case Activity.writtenComments:
        PostActivityModel act = activityModel;
        return 'علقت على ${(act.postWriterId == controller.currentUserId) ? 'منشورك' : 'منشور ${(act.postWriterType == UserType.doctor) ? (act.postWriterGender == Gender.male) ? 'الطبيب ' : 'الطبيبة ' : ''}${act.postWriterName}'}';
      case Activity.likedComments:
        CommentActivityModel act = activityModel;
        return 'تفاعلت مع ${(act.commentWriterId == controller.currentUserId) ? 'تعليقك' : 'تعليق ${(act.commentWriterType == UserType.doctor) ? (act.commentWriterGender == Gender.male) ? 'الطبيب ' : 'الطبيبة ' : ''}${act.commentWriterName}'}';
      case Activity.writtenReplies:
        CommentActivityModel act = activityModel;
        return 'قمت بالرد على ${(act.commentWriterId == controller.currentUserId) ? 'تعليقك' : 'تعليق ${(act.commentWriterType == UserType.doctor) ? (act.commentWriterGender == Gender.male) ? 'الطبيب ' : 'الطبيبة ' : ''}${act.commentWriterName}'} على ${(act.postWriterId == controller.currentUserId) ? 'منشورك' : 'منشور ${(act.postWriterType == UserType.doctor) ? (act.postWriterGender == Gender.male) ? 'الطبيب ' : 'الطبيبة ' : ''}${act.postWriterName}'}';
      case Activity.likedReplies:
        ReplyActivityModel act = activityModel;
        return 'تفاعلت مع ${(act.replyWriterId == controller.currentUserId) ? 'ردك' : 'رد ${(act.replyWriterType == UserType.doctor) ? (act.replyWriterGender == Gender.male) ? 'الطبيب ' : 'الطبيبة ' : ''}${act.replyWriterName}'}';
    }
  }

  String get _getActivityId {
    switch (activity) {
      case Activity.likedPosts:
        return activityModel.postId;
      case Activity.likedComments:
        return activityModel.commentId;
      case Activity.likedReplies:
        return activityModel.replyId;
      case Activity.writtenComments:
        return activityModel.id;
      case Activity.writtenReplies:
        return activityModel.id;
    }
  }

  String get _getActivityImage {
    switch (activity) {
      case Activity.likedPosts:
      case Activity.likedComments:
      case Activity.likedReplies:
        return 'assets/img/like.png';
      case Activity.writtenComments:
      case Activity.writtenReplies:
        return 'assets/img/comment.png';
    }
  }

  _onActivityPressed(BuildContext context) {
    final controller = ActivityPageController.find(activity.name);
    MyAlertDialog.showLoadingDialog(context);
    controller.getActivityOnPressed(activityModel)();
  }
}
