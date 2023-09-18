import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/medical_record/model/medicine.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/data/models/age.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:clinic/global/widgets/error_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CommonFunctions {
  static String getFullName(String firstName, String lastName) =>
      '$firstName $lastName';
  static ErrorPage get internetError => const ErrorPage(
      imageAsset: 'assets/img/internet-error.svg',
      message: 'حدثت مشكلة حاول الإتصال بالإنترنت وإعادة المحاولة');
  static void errorHappened() => Get.to(() => const ErrorPage(
        imageAsset: 'assets/img/error.svg',
        message: '  حدثت مشكلة، يرجى إعادة المحاولة لاحقاً',
      ));
  static void deletedElement() => Get.to(
        () => const ErrorPage(
            imageAsset: 'assets/img/error.svg',
            message: 'المحتوى غير متوفر بعد الأن'),
      );

  static bool isLightMode(BuildContext context) =>
      (Theme.of(context).brightness == Brightness.light);

  static Timestamp timestampFromTimeOfDay(TimeOfDay timeOfDay) {
    DateTime dateTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
    return Timestamp.fromDate(dateTime);
  }

  static TimeOfDay timeOfDayFromTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return TimeOfDay.fromDateTime(dateTime);
  }

  static Age calculateAge(Timestamp birthdate) {
    DateTime now = DateTime.now();
    DateTime birthDateTime = birthdate.toDate();

    int years = now.year - birthDateTime.year;
    int months = now.month - birthDateTime.month;
    int days = now.day - birthDateTime.day;

    if (days < 0) {
      months--;
      days += birthDateTime.day;
    }

    if (months < 0) {
      years--;
      months += DateTime.monthsPerYear;
    }

    return Age(years: years, months: months, days: days);
  }

  static String getNumberOfReactsText(int reacts) {
    double newReacts;
    if (reacts < 1000) {
      return reacts.toString();
    } else if (reacts >= 1000 && reacts < 1000000) {
      newReacts = (reacts / 1000);
      return newReacts
          .toStringAsFixed(((newReacts * 10).floor() % 10 == 0) ? 0 : 1);
    } else {
      newReacts = (reacts / 1000000);
      return newReacts
          .toStringAsFixed(((newReacts * 10).floor() % 10 == 0) ? 0 : 1);
    }
  }

  static String getMultiplierText(int reacts) {
    if (reacts >= 1000 && reacts < 1000000) {
      return 'ألف ';
    } else {
      return 'مليون ';
    }
  }

  static int calculateTimeDifferenceInMinutes(
      DateTime startTime, DateTime endTime) {
    final difference = endTime.difference(startTime);
    return difference.inMinutes;
  }

  static int calculateTimeDifferenceInDays(
      DateTime startTime, DateTime endTime) {
    final difference = endTime.difference(startTime);
    return difference.inDays;
  }

  static String getTime(Timestamp time) {
    DateTime timeInDateTime = time.toDate();
    int hour = timeInDateTime.hour > 12
        ? timeInDateTime.hour - 12
        : timeInDateTime.hour;
    String amOrPm = timeInDateTime.hour >= 12 ? 'PM' : 'AM';
    String finalHour = hour < 10 ? '0$hour' : '$hour';
    String minute = timeInDateTime.minute < 10
        ? '0${timeInDateTime.minute}'
        : '${timeInDateTime.minute}';

    return '$finalHour:$minute' '$amOrPm';
  }

  static String getDate(Timestamp date) {
    DateTime dateInDateTime = date.toDate();
    if (isToday(dateInDateTime)) {
      return 'اليوم';
    } else if (isYesterday(dateInDateTime)) {
      return 'أمس';
    } else {
      return dateInDateTime.toString().substring(0, 10);
    }
  }

  static bool isToday(DateTime date) {
    return ((DateTime.now().year == date.year) &&
        (DateTime.now().month == date.month) &&
        (DateTime.now().day == date.day));
  }

  static bool isYesterday(DateTime date) {
    DateTime yesterdayDate = DateTime.now().subtract(const Duration(days: 1));
    return ((yesterdayDate.year == date.year) &&
        (yesterdayDate.month == date.month) &&
        (yesterdayDate.day == date.day));
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return ((date1.year == date2.year) &&
        (date1.month == date2.month) &&
        (date1.day == date2.day));
  }

  static bool containsPhoneNumber(String input) {
    const pattern = r'\b\d{3}[-.]?\d{3}[-.]?\d{4}\b';
    final regex = RegExp(pattern);
    return regex.hasMatch(input);
  }

  static int countMatches(String inputString, String pattern) {
    RegExp regExp = RegExp(pattern);
    Iterable<RegExpMatch> matches = regExp.allMatches(inputString);
    return matches.length;
  }

  static List<TextSpan> extractText(BuildContext context, String rawString,
      {Color linkTextColor = Colors.blue, Color phoneTextColor = Colors.blue}) {
    List<TextSpan> textSpan = [];
    final urlRegExp = RegExp(AppConstants.urlRegex);
    final phoneRegExp = RegExp(AppConstants.phoneNumberRegex);

    getLink(String linkString) {
      if (linkString.startsWith('www')) {
        linkString = 'https://$linkString';
      }
      textSpan.add(
        TextSpan(
          text: linkString,
          style: TextStyle(
            color: linkTextColor,
            fontStyle: FontStyle.italic,
            shadows: const [
              BoxShadow(
                color: Colors.black38,
                spreadRadius: 0.5,
                blurRadius: 1,
                offset: Offset(0, 0.5),
              ),
            ],
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              MyAlertDialog.showAlertDialog(
                context,
                'الإنتقال إلى الرابط',
                'هل أنت متأكد من الإنتقال إلى الرابط التالي:\n $linkString',
                MyAlertDialog.getAlertDialogActions(
                  {
                    'العودة': () => Get.back(),
                    'الإنتقال': () async {
                      Get.back();
                      if (await canLaunchUrlString(linkString)) {
                        launchUrlString(
                          linkString,
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        errorHappened();
                      }
                    }
                  },
                ),
              );
            },
        ),
      );
      return linkString;
    }

    getPhoneNumber(String phoneString) {
      textSpan.add(
        TextSpan(
          text: phoneString,
          style: TextStyle(
            color: phoneTextColor,
            shadows: const [
              BoxShadow(
                color: Colors.black38,
                spreadRadius: 0.5,
                blurRadius: 1,
                offset: Offset(0, 0.5),
              ),
            ],
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              Uri phoneUrl = Uri(
                scheme: 'tel',
                path: phoneString,
              );
              if (await canLaunchUrl(phoneUrl)) {
                launchUrl(
                  phoneUrl,
                  mode: LaunchMode.externalApplication,
                );
              } else {
                errorHappened();
              }
            },
        ),
      );
      return phoneString;
    }

    getNormalText(String normalText) {
      textSpan.add(
        TextSpan(
          text: normalText,
        ),
      );
      return normalText;
    }

    rawString.splitMapJoin(
      urlRegExp,
      onMatch: (m) => getLink("${m.group(0)}"),
    );
    rawString.splitMapJoin(
      phoneRegExp,
      onMatch: (m) => getPhoneNumber("${m.group(0)}"),
    );
    rawString.splitMapJoin(
      RegExp('(${urlRegExp.pattern})|(${phoneRegExp.pattern})'),
      onNonMatch: (n) => getNormalText(n.substring(0)),
    );
    return textSpan;
  }

  static bool isCurrentUser(String uid) => uid == currentUserId;
  static String get currentUserId =>
      AuthenticationController.find.currentUserId;
  static String get currentUserName =>
      AuthenticationController.find.currentUserName;
  static String get currentDoctorSpecialization =>
      AuthenticationController.find.currentDoctorSpecialization;
  static String? get currentUserPersonalImage =>
      AuthenticationController.find.currentUserPersonalImage;
  static UserType get currentUserType =>
      AuthenticationController.find.currentUserType;
}

String getMedicineTypeName(Medicine medicineType) {
  switch (medicineType) {
    case Medicine.pills:
      return 'حبوب';
    case Medicine.syrup:
      return 'شراب';
    case Medicine.syringe:
      return 'حقن';
    case Medicine.cream:
      return 'دهان';
    case Medicine.nasalSpray:
      return 'بخاخ للأنف';
    case Medicine.suppository:
      return 'لبوس';
    case Medicine.mouthRinse:
      return 'مضمضة للفم';
  }
}

String getMedicineTypeImageAsset(Medicine medicineType) {
  switch (medicineType) {
    case Medicine.pills:
      return 'assets/img/pills.png';
    case Medicine.syrup:
      return 'assets/img/syrup.png';
    case Medicine.syringe:
      return 'assets/img/syringe.png';
    case Medicine.cream:
      return 'assets/img/cream.png';
    case Medicine.nasalSpray:
      return 'assets/img/nasal-spray.png';
    case Medicine.suppository:
      return 'assets/img/suppository.png';
    case Medicine.mouthRinse:
      return 'assets/img/mouth-rinse.png';
  }
}

String getPerHowMuchDays(int perHowMuchDays) {
  switch (perHowMuchDays) {
    case 1:
      return 'يوم';
    case 2:
      return 'يومين';
    case 3:
    case 4:
    case 5:
    case 6:
    case 7:
    case 9:
    case 10:
      return 'أيام ';
    default:
      return 'يوم ';
  }
}
