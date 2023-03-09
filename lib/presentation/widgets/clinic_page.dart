import 'package:clinic/presentation/Providers/inherited_widgets/parent_user_provider.dart';
import 'package:flutter/material.dart';

import 'package:clinic/global/constants/am_or_pm.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/constants/regions.dart';
import 'package:clinic/global/theme/colors/light_theme_colors.dart';
import 'package:clinic/global/theme/fonts/app_fonst.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:clinic/global/widgets/day.dart';

class ClinicPage extends StatefulWidget {
  final int index;
  const ClinicPage({
    super.key,
    required this.index,
  });

  @override
  State<ClinicPage> createState() => _ClinicPageState();
}

class _ClinicPageState extends State<ClinicPage> {
  bool _examineVezeetaValid = true;
  bool _reexamineVezeetaValid = true;

  @override
  Widget build(BuildContext context) {
    var doctorProvider = ParentUserProvider.of(context);
    var clinicModel = doctorProvider!.doctorModel!.clinics[widget.index];
    return Column(
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: LightThemeColors.primaryColor,
                borderRadius: BorderRadius.circular(8)),
            child: Text(
              ' عيادة رقم ${widget.index + 1}',
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
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            MyAlertDialog.getInfoAlertDialog(
              context,
              'أين باقي المحافظات؟',
              AppConstants.whereIsRestGovernorates,
              {
                'أعي ذلك': () => Navigator.of(context).pop(),
              },
            ),
            const Text(
              'المحافظة',
              style: TextStyle(
                fontFamily: AppFonts.mainArabicFontFamily,
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: LightThemeColors.primaryColor,
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.only(
              left: 15,
              right: 5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: LightThemeColors.primaryColor,
                width: 1,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                items: Regions.governorates
                    .map(
                      (governorate) => DropdownMenuItem(
                        value: governorate,
                        child: Text(
                          governorate,
                          style: const TextStyle(
                              fontFamily: AppFonts.mainArabicFontFamily),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (item) {
                  setState(() {
                    clinicModel.governorate = item!;
                  });
                },
                value: clinicModel.governorate,
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            MyAlertDialog.getInfoAlertDialog(
              context,
              'المنطقة الجغرافية',
              AppConstants.regionInfo,
              {
                'أعي ذلك': () => Navigator.of(context).pop(),
              },
            ),
            const Text(
              'المنطقة',
              style: TextStyle(
                fontFamily: AppFonts.mainArabicFontFamily,
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: LightThemeColors.primaryColor,
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.only(
              left: 15,
              right: 5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: LightThemeColors.primaryColor,
                width: 1,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                items: Regions.regions.keys
                    .map(
                      (region) => DropdownMenuItem(
                        value: region,
                        child: Text(
                          region,
                          style: const TextStyle(
                              fontFamily: AppFonts.mainArabicFontFamily),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (item) {
                  setState(() {
                    clinicModel.region = item!;
                  });
                },
                value: clinicModel.region,
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
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
                clinicModel.location = 'location is set !!';
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
            (clinicModel.location != null)
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
          children: Day.getClickableWeekDays(clinicModel.workDays, (day) {
            setState(() {
              clinicModel.workDays[day] = !clinicModel.workDays[day]!;
            });
          }, context),
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
                    context: context, initialTime: clinicModel.closeTime);

                setState(() {
                  clinicModel.closeTime =
                      (picked == null) ? clinicModel.closeTime : picked;
                  clinicModel.closeTimeFinalMin =
                      (clinicModel.closeTime.minute < 10)
                          ? (AppConstants.zero +
                              clinicModel.closeTime.minute.toString())
                          : (clinicModel.closeTime.minute.toString());
                  if (clinicModel.closeTime.hour > 12) {
                    clinicModel.closeTimeFinalHour =
                        (clinicModel.closeTime.hour - 12).toString();
                    clinicModel.closeTimeAMOrPM = AMOrPM.pm;
                  } else {
                    clinicModel.closeTimeFinalHour =
                        (clinicModel.closeTime.hour == 0)
                            ? '12'
                            : (clinicModel.closeTime.hour).toString();
                    clinicModel.closeTimeAMOrPM =
                        (clinicModel.closeTime.hour == 12)
                            ? AMOrPM.pm
                            : AMOrPM.am;
                  }
                });
              },
              child: Text(
                '${clinicModel.closeTimeFinalHour} : ${clinicModel.closeTimeFinalMin} ${clinicModel.closeTimeAMOrPM.name.toUpperCase()}',
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
                    context: context, initialTime: clinicModel.openTime);

                setState(() {
                  clinicModel.openTime =
                      (picked == null) ? clinicModel.openTime : picked;
                  clinicModel.openTimeFinalMin =
                      (clinicModel.openTime.minute < 10)
                          ? (AppConstants.zero +
                              clinicModel.openTime.minute.toString())
                          : (clinicModel.openTime.minute.toString());
                  if (clinicModel.openTime.hour > 12) {
                    clinicModel.openTimeFinalHour =
                        (clinicModel.openTime.hour - 12).toString();
                    clinicModel.openTimeAMOrPM = AMOrPM.pm;
                  } else {
                    clinicModel.openTimeFinalHour =
                        (clinicModel.openTime.hour == 0)
                            ? '12'
                            : (clinicModel.openTime.hour).toString();
                    clinicModel.openTimeAMOrPM =
                        (clinicModel.openTime.hour == 12)
                            ? AMOrPM.pm
                            : AMOrPM.am;
                  }
                });
              },
              child: Text(
                '${clinicModel.openTimeFinalHour} : ${clinicModel.openTimeFinalMin} ${clinicModel.openTimeAMOrPM.name.toUpperCase()}',
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
          key: clinicModel.formKey,
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
                            _examineVezeetaValid = false;
                          });
                          return 'من فضلك ادخل السعر  ';
                        } else {
                          setState(() {
                            _examineVezeetaValid =
                                RegExp(AppConstants.vezeetaValidationRegExp)
                                    .hasMatch(value);
                          });
                          if (!_examineVezeetaValid) {
                            return 'من فضلك ادخل قيمة صحيحة ';
                          }
                        }
                        clinicModel.examineVezeeta = int.parse(value);
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
                          color: _examineVezeetaValid
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
                  'سعر الإستشارة',
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
                            _reexamineVezeetaValid = false;
                          });
                          return 'من فضلك ادخل السعر  ';
                        } else {
                          setState(() {
                            _reexamineVezeetaValid =
                                RegExp(AppConstants.vezeetaValidationRegExp)
                                    .hasMatch(value);
                          });
                          if (!_reexamineVezeetaValid) {
                            return 'من فضلك ادخل قيمة صحيحة ';
                          }
                        }
                        clinicModel.reexamineVezeeta = int.parse(value);

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
                          color: _reexamineVezeetaValid
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
