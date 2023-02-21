import 'package:clinic/global/constants/app_constants.dart';
import 'package:flutter/material.dart';

import '../../global/constants/am_or_pm.dart';
import '../../global/theme/colors/light_theme_colors.dart';
import '../../global/theme/fonts/app_fonst.dart';
import '../../global/widgets/day.dart';

// ignore: must_be_immutable
class Clinic extends StatefulWidget {
  final formKey = GlobalKey<FormState>();

  int index;
  bool locationIsSet;
  bool examineVezeetaValid = true;
  bool reexamineVezeetaValid = true;
  Map<String, bool> workDays = {};
  TimeOfDay openTime;
  TimeOfDay closeTime;
  String openTimeFinalMin;
  String openTimeFinalHour;
  String closeTimeFinalMin;
  String closeTimeFinalHour;
  AMOrPM openTimeAMOrPM;
  AMOrPM closeTimeAMOrPM;

  Clinic({
    super.key,
    required this.index,
    this.locationIsSet = false,
    this.openTime = AppConstants.initialOpenTime,
    this.closeTime = AppConstants.initialCloseTime,
    this.openTimeFinalMin = AppConstants.initialOpenTimeFinalMin,
    this.openTimeFinalHour = AppConstants.initialOpenTimeFinalHour,
    this.closeTimeFinalMin = AppConstants.initialCloseTimeFinalMin,
    this.closeTimeFinalHour = AppConstants.initialCloseTimeFinalHour,
    this.openTimeAMOrPM = AppConstants.initialAmOrPm,
    this.closeTimeAMOrPM = AppConstants.initialAmOrPm,
  });

  @override
  State<Clinic> createState() => _ClinicState();
}

class _ClinicState extends State<Clinic> {
  @override
  void initState() {
    super.initState();
    widget.workDays = Map<String, bool>.fromIterables(
        AppConstants.weekDays, AppConstants.initialCheckedDays);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: LightThemeColors.primaryColor,
                borderRadius: BorderRadius.circular(8)),
            child: Text(
              ' عيادة رقم ${widget.index}',
              style: const TextStyle(
                fontFamily: AppFonts.mainArabicFontFamily,
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Align(
          alignment: Alignment.centerRight,
          child: Text(
            'موقع العيادة',
            style: TextStyle(
              fontFamily: AppFonts.mainArabicFontFamily,
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: LightThemeColors.primaryColor,
            ),
          ),
        ),
        Row(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(
                    color: LightThemeColors.primaryColor,
                  ),
                ),
                backgroundColor: Colors.white,
                foregroundColor: LightThemeColors.primaryColor,
              ),
              onPressed: () => setState(() {
                widget.locationIsSet = true;
              }),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: Colors.grey[900],
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    'تحديد الموقع',
                    style: TextStyle(
                        color: Colors.grey[900],
                        fontFamily: AppFonts.mainArabicFontFamily,
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                  )
                ],
              ),
            ),
            const SizedBox(width: 10),
            widget.locationIsSet
                ? const Icon(
                    Icons.done_rounded,
                    color: Colors.green,
                  )
                : const Icon(
                    Icons.close_rounded,
                    color: Colors.red,
                  )
          ],
        ),
        const SizedBox(height: 30),
        const Align(
          alignment: Alignment.centerRight,
          child: Text(
            'أيام العمل',
            style: TextStyle(
              fontFamily: AppFonts.mainArabicFontFamily,
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: LightThemeColors.primaryColor,
            ),
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: Day.getClickableWeekDays(widget.workDays, (day) {
            setState(() {
              if (widget.workDays[day] != null) {
                widget.workDays[day] = !widget.workDays[day]!;
              }
            });
          }),
        ),
        const SizedBox(height: 30),
        const Align(
          alignment: Alignment.centerRight,
          child: Text(
            'ساعات العمل',
            style: TextStyle(
              fontFamily: AppFonts.mainArabicFontFamily,
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: LightThemeColors.primaryColor,
            ),
          ),
        ),
        Row(
          children: [
            TextButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(
                    color: LightThemeColors.primaryColor,
                  ),
                ),
                backgroundColor: Colors.white,
                foregroundColor: LightThemeColors.primaryColor,
              ),
              onPressed: () async {
                TimeOfDay? picked;
                picked = await showTimePicker(
                    context: context, initialTime: widget.closeTime);

                setState(() {
                  widget.closeTime =
                      (picked == null) ? widget.closeTime : picked;
                  widget.closeTimeFinalMin = (widget.closeTime.minute < 10)
                      ? (AppConstants.zero + widget.closeTime.minute.toString())
                      : (widget.closeTime.minute.toString());
                  if (widget.closeTime.hour > 12) {
                    widget.closeTimeFinalHour =
                        (widget.closeTime.hour - 12).toString();
                    widget.closeTimeAMOrPM = AMOrPM.pm;
                  } else {
                    widget.closeTimeFinalHour = (widget.closeTime.hour == 0)
                        ? '12'
                        : (widget.closeTime.hour).toString();
                    widget.closeTimeAMOrPM =
                        (widget.closeTime.hour == 12) ? AMOrPM.pm : AMOrPM.am;
                  }
                });
              },
              child: Text(
                '${widget.closeTimeFinalHour} : ${widget.closeTimeFinalMin} ${widget.closeTimeAMOrPM.name.toUpperCase()}',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'إلى',
              style: TextStyle(
                  fontFamily: AppFonts.mainArabicFontFamily,
                  color: Colors.grey[900],
                  fontSize: 15),
            ),
            const SizedBox(width: 10),
            TextButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(
                    color: LightThemeColors.primaryColor,
                  ),
                ),
                backgroundColor: Colors.white,
                foregroundColor: LightThemeColors.primaryColor,
              ),
              onPressed: () async {
                TimeOfDay? picked;

                picked = await showTimePicker(
                    context: context, initialTime: widget.openTime);

                setState(() {
                  widget.openTime = (picked == null) ? widget.openTime : picked;
                  widget.openTimeFinalMin = (widget.openTime.minute < 10)
                      ? (AppConstants.zero + widget.openTime.minute.toString())
                      : (widget.openTime.minute.toString());
                  if (widget.openTime.hour > 12) {
                    widget.openTimeFinalHour =
                        (widget.openTime.hour - 12).toString();
                    widget.openTimeAMOrPM = AMOrPM.pm;
                  } else {
                    widget.openTimeFinalHour = (widget.openTime.hour == 0)
                        ? '12'
                        : (widget.openTime.hour).toString();
                    widget.openTimeAMOrPM =
                        (widget.openTime.hour == 12) ? AMOrPM.pm : AMOrPM.am;
                  }
                });
              },
              child: Text(
                '${widget.openTimeFinalHour} : ${widget.openTimeFinalMin} ${widget.openTimeAMOrPM.name.toUpperCase()}',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'من',
              style: TextStyle(
                  fontFamily: AppFonts.mainArabicFontFamily,
                  color: Colors.grey[900],
                  fontSize: 15),
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Form(
          key: widget.formKey,
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'سعر الكشف',
                  style: TextStyle(
                    fontFamily: AppFonts.mainArabicFontFamily,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: LightThemeColors.primaryColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 130),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      validator: ((value) {
                        if (value == null || value.trim().isEmpty) {
                          setState(() {
                            widget.examineVezeetaValid = false;
                          });
                          return 'من فضلك ادخل السعر  ';
                        } else {
                          setState(() {
                            widget.examineVezeetaValid =
                                RegExp(AppConstants.vezeetaValidationRegExp)
                                    .hasMatch(value);
                          });
                          if (!widget.examineVezeetaValid) {
                            return 'من فضلك ادخل قيمة صحيحة ';
                          }
                        }
                        return null;
                      }),
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      decoration: const InputDecoration(
                        counter: Offstage(),
                      ),
                    ),
                    Container(
                      width: 20,
                      height: 5,
                      decoration: BoxDecoration(
                          color: widget.examineVezeetaValid
                              ? LightThemeColors.primaryColor
                              : Colors.red,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'سعر إعادة الكشف',
                  style: TextStyle(
                    fontFamily: AppFonts.mainArabicFontFamily,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: LightThemeColors.primaryColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 130),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      validator: ((value) {
                        if (value == null || value.trim().isEmpty) {
                          setState(() {
                            widget.reexamineVezeetaValid = false;
                          });
                          return 'من فضلك ادخل السعر  ';
                        } else {
                          setState(() {
                            widget.reexamineVezeetaValid =
                                RegExp(AppConstants.vezeetaValidationRegExp)
                                    .hasMatch(value);
                          });
                          if (!widget.reexamineVezeetaValid) {
                            return 'من فضلك ادخل قيمة صحيحة ';
                          }
                        }
                        return null;
                      }),
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      decoration: const InputDecoration(
                        counter: Offstage(),
                      ),
                    ),
                    Container(
                      width: 20,
                      height: 5,
                      decoration: BoxDecoration(
                          color: widget.reexamineVezeetaValid
                              ? LightThemeColors.primaryColor
                              : Colors.red,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 40,
        )
      ],
    );
  }
}
