import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinic/features/chat/pages/message/message_time_widget.dart';
import 'package:clinic/features/notifications/model/notification_model.dart';
import 'package:clinic/features/notifications/model/notification_type.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/notify_widget.dart';
import 'package:flutter/material.dart';

class SingleNotification extends StatelessWidget {
  const SingleNotification({
    Key? key,
    required this.onPressed,
    required this.notification,
  }) : super(key: key);
  final void Function() onPressed;
  final NotificationModel notification;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onPressed(),
      trailing: (notification.notifierPic == null)
          ? CircleAvatar(
              backgroundImage: const AssetImage('assets/img/user.png'),
              radius: 25,
              backgroundColor: (CommonFunctions.isLightMode(context))
                  ? Colors.grey.shade100
                  : AppColors.darkThemeBackgroundColor,
            )
          : CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                notification.notifierPic!,
              ),
              radius: 25,
              backgroundColor:
                  (Theme.of(context).brightness == Brightness.light)
                      ? Colors.grey.shade100
                      : AppColors.darkThemeBackgroundColor,
            ),
      title: Align(
        alignment: Alignment.centerRight,
        child: Text(
          _notificationText,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          style: const TextStyle(
            fontFamily: AppFonts.mainArabicFontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            CommonFunctions.getDate(notification.time),
            style: const TextStyle(
              fontFamily: AppFonts.mainArabicFontFamily,
              fontSize: 9,
            ),
          ),
          MessageTimeWidget(messageTime: notification.time),
          (!notification.seen ||
                  CommonFunctions.calculateTimeDifferenceInMinutes(
                        notification.seenTime!.toDate(),
                        DateTime.now(),
                      ) <
                      5)
              ? NotifyWidget(
                  size: 10,
                  color: ((notification.type ==
                              NotificationType.searchingForMySpecialization) &&
                          (notification.data['is_ergent']))
                      ? Colors.red
                      : Colors.green,
                  shadowColor: ((notification.type ==
                              NotificationType.searchingForMySpecialization) &&
                          (notification.data['is_ergent']))
                      ? Colors.redAccent
                      : Colors.lightGreen,
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  String get _notificationText {
    String notifierName = notification.notifierName;
    UserType notifierType = notification.notifierType;
    Gender notifierGender = notification.notifierGender;
    String title = '';
    switch (notification.type) {
      case NotificationType.newFollow:
        title =
            '${(notifierGender == Gender.male) ? ' بدأ ' : ' بدأت '}${(notifierType == UserType.doctor) ? (notifierGender == Gender.male) ? 'الطبيب ' : 'الطبيبة ' : ''}$notifierName متابعتك';
        break;

      case NotificationType.reactMyPost:
        title =
            '${(notifierGender == Gender.male) ? ' قام ' : ' قامت '}${(notifierType == UserType.doctor) ? (notifierGender == Gender.male) ? 'الطبيب ' : 'الطبيبة ' : ''}$notifierName بالتفاعل مع منشورك';

        break;

      case NotificationType.reactMyComment:
        title =
            '${(notifierGender == Gender.male) ? ' قام ' : ' قامت '}${(notifierType == UserType.doctor) ? (notifierGender == Gender.male) ? 'الطبيب ' : 'الطبيبة ' : ''}$notifierName بالتفاعل مع تعليقك';
        break;

      case NotificationType.reactMyReply:
        title =
            '${(notifierGender == Gender.male) ? ' قام ' : ' قامت '}${(notifierType == UserType.doctor) ? (notifierGender == Gender.male) ? 'الطبيب ' : 'الطبيبة ' : ''}$notifierName بالتفاعل مع ردك';
        break;

      case NotificationType.commentMyPost:
        title =
            '${(notifierGender == Gender.male) ? ' قام ' : ' قامت '}${(notifierType == UserType.doctor) ? (notifierGender == Gender.male) ? 'الطبيب ' : 'الطبيبة ' : ''}$notifierName بالتعليق على منشورك';
        break;

      case NotificationType.commentOnPostICommented:
        title =
            '${(notifierGender == Gender.male) ? ' قام ' : ' قامت '}${(notifierType == UserType.doctor) ? (notifierGender == Gender.male) ? 'الطبيب ' : 'الطبيبة ' : ''}$notifierName بالتعليق على منشور تابعته';
        break;

      case NotificationType.replyMyComment:
        title =
            '${(notifierGender == Gender.male) ? ' قام ' : ' قامت '}${(notifierType == UserType.doctor) ? (notifierGender == Gender.male) ? 'الطبيب ' : 'الطبيبة ' : ''}$notifierName بالرد على تعليقك';
        break;

      case NotificationType.replyOnMyPost:
        title =
            '${(notifierGender == Gender.male) ? ' قام ' : ' قامت '}${(notifierType == UserType.doctor) ? (notifierGender == Gender.male) ? 'الطبيب ' : 'الطبيبة ' : ''}$notifierName بالرد على تعليق في منشورك';
        break;

      case NotificationType.replyOnCommentIReplied:
        title =
            '${(notifierGender == Gender.male) ? ' قام ' : ' قامت '}${(notifierType == UserType.doctor) ? (notifierGender == Gender.male) ? 'الطبيب ' : 'الطبيبة ' : ''}$notifierName بالرد على تعليق تابعته';
        break;

      case NotificationType.searchingForMySpecialization:
        title =
            '${(notification.data['is_ergent']) ? 'حالة طارئة!!\n' : ''}${(notifierGender == Gender.male) ? ' يبحث ' : ' تبحث '}$notifierName  عن ${notification.data['specialization']}';
        break;

      case NotificationType.followedDoctorPost:
        title =
            '${(notifierGender == Gender.male) ? ' قام ' : ' قامت '}${(notifierGender == Gender.male) ? 'الطبيب ' : 'الطبيبة '}$notifierName بإضافة منشور جديد';
        break;

      case NotificationType.followedDoctorNewClinicPost:
        title =
            '${(notifierGender == Gender.male) ? ' قام ' : ' قامت '}${(notifierGender == Gender.male) ? 'الطبيب ' : 'الطبيبة '}$notifierName بالنشر عن عيادة جديدة';
        break;

      case NotificationType.followedDoctorDiscountPost:
        title =
            '${(notifierGender == Gender.male) ? ' قام ' : ' قامت '}${(notifierGender == Gender.male) ? 'الطبيب ' : 'الطبيبة '}$notifierName بالنشر عن تخفيض لقيمة الكشف';
        break;

      case NotificationType.followedDoctorMedicalInfoPost:
        title =
            '${(notifierGender == Gender.male) ? ' قام ' : ' قامت '}${(notifierGender == Gender.male) ? 'الطبيب ' : 'الطبيبة '}$notifierName بنشر معلومة طبية جديدة';
        break;
      case NotificationType.followedDoctorNewDegreePost:
        title =
            '${(notifierGender == Gender.male) ? ' حصل ' : ' حصلت '}${(notifierGender == Gender.male) ? 'الطبيب ' : 'الطبيبة '}$notifierName على درجة علمية جديدة';
        break;
    }
    return title;
  }
}
