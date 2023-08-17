import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/medical_record/model/medicine.dart';
import 'package:clinic/global/constants/am_or_pm.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/data/models/age.dart';
import 'package:clinic/global/widgets/error_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  static bool isLightMode(BuildContext context) =>
      (Theme.of(context).brightness == Brightness.light);

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

  static bool isToday(DateTime date) {
    return ((DateTime.now().year == date.year) &&
        (DateTime.now().month == date.month) &&
        (DateTime.now().day == date.day));
  }

  static bool isYesterday(DateTime date) {
    return ((DateTime.now().year == date.year) &&
            (DateTime.now().month == date.month) &&
            (DateTime.now().day - date.day == 1)) ||
        ((DateTime.now().year == date.year) &&
            (DateTime.now().month - date.month == 1) &&
            (DateTime.now().day == 1)) ||
        ((DateTime.now().year - date.year == 1) &&
            (DateTime.now().month == 1) &&
            (DateTime.now().day == 1));
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return ((date1.year == date2.year) &&
        (date1.month == date2.month) &&
        (date1.day == date2.day));
  }

  static bool isCurrentUser(String uid) => uid == currentUserId;
  static String get currentUserId =>
      AuthenticationController.find.currentUserId;
  static String get currentUserName =>
      AuthenticationController.find.currentUserName;
  static String? get currentUserPersonalImage =>
      AuthenticationController.find.currentUserPersonalImage;
  static UserType get currentUserType =>
      AuthenticationController.find.currentUserType;
}

TimeOfDay setClinicOpenTime(
    String openHour, String openMin, AMOrPM openAmOrPm) {
  TimeOfDay openTime;
  if (openHour == '12') {
    openHour = AppConstants.zero;
  }
  if (openAmOrPm == AMOrPM.am) {
    openTime = TimeOfDay(hour: int.parse(openHour), minute: int.parse(openMin));
  } else {
    openTime =
        TimeOfDay(hour: int.parse(openHour) + 12, minute: int.parse(openMin));
  }

  return openTime;
}

TimeOfDay setClinicCloseTime(
    String closeHour, String closeMin, AMOrPM closeAmOrpm) {
  TimeOfDay closeTime;
  if (closeHour == '12') {
    closeHour = AppConstants.zero;
  }
  if (closeAmOrpm == AMOrPM.am) {
    closeTime =
        TimeOfDay(hour: int.parse(closeHour), minute: int.parse(closeMin));
  } else {
    closeTime =
        TimeOfDay(hour: int.parse(closeHour) + 12, minute: int.parse(closeMin));
  }

  return closeTime;
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
