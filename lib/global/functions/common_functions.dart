import 'package:clinic/global/constants/am_or_pm.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:flutter/material.dart';

class CommonFunctions {
  static String getFullName(String firstName, String lastName) =>
      '$firstName $lastName';
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
