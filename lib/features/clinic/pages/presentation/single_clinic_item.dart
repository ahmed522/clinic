import 'package:clinic/features/clinic/model/clinic_model.dart';
import 'package:clinic/global/widgets/doctor_specialization_info_widget.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/info_widget.dart';
import 'package:flutter/material.dart';

class SingleClinicItem extends StatelessWidget {
  const SingleClinicItem(
      {super.key,
      required this.clinic,
      required this.onTap,
      this.title,
      this.gender});
  final ClinicModel clinic;
  final void Function() onTap;
  final String? title;
  final Gender? gender;
  @override
  Widget build(BuildContext context) {
    bool isClinicOpen = CommonFunctions.isClinicOpen(
      clinic.openTime.toDate(),
      clinic.closeTime.toDate(),
      clinic.workDays,
    );

    Gender doctorGender = gender ?? clinic.doctorGender;
    return GestureDetector(
      onTap: () => onTap(),
      child: Card(
        margin: const EdgeInsets.only(bottom: 5.0, right: 10.0, left: 10.0),
        color: CommonFunctions.isLightMode(context)
            ? Colors.white
            : AppColors.darkThemeBottomNavBarColor,
        elevation: 2.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(width: .0001),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoWidget(
                    text: '${clinic.region} - ${clinic.governorate}',
                    icon: Icons.location_on_outlined,
                  ),
                  Text(
                    isClinicOpen ? 'مفتوح' : 'مغلق',
                    style: TextStyle(
                      color: isClinicOpen ? Colors.green : Colors.red,
                      fontFamily: AppFonts.mainArabicFontFamily,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5.0,
              ),
              Align(
                alignment: Alignment.topRight,
                child: (title == null)
                    ? RichText(
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        text: TextSpan(
                            text:
                                'عيادة ${(clinic.doctorGender == Gender.male) ? 'الطبيب' : 'الطبيبة'}',
                            style: TextStyle(
                              color: (CommonFunctions.isLightMode(context))
                                  ? Colors.black87
                                  : Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              fontFamily: AppFonts.mainArabicFontFamily,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: ' ${clinic.doctorName!}',
                                style: TextStyle(
                                  color: (CommonFunctions.isLightMode(context))
                                      ? Colors.black87
                                      : Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: AppFonts.mainArabicFontFamily,
                                ),
                              ),
                            ]),
                      )
                    : Text(
                        title!,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: (CommonFunctions.isLightMode(context))
                              ? Colors.black87
                              : Colors.white,
                          fontSize: 15,
                        ),
                      ),
              ),
              const SizedBox(height: 10.0),
              Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DoctorSpecializationInfoWidget(
                        specialization: clinic.specialization!),
                    const SizedBox(width: 3.0),
                    Image.asset(
                      doctorGender == Gender.male
                          ? 'assets/img/male-doctor.png'
                          : 'assets/img/female-doctor.png',
                      width: 30,
                      height: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
