import 'package:clinic/features/clinic/pages/creation/set_clinic_governorate_widget.dart';
import 'package:clinic/features/clinic/pages/creation/set_clinic_location_widget.dart';
import 'package:clinic/features/clinic/pages/creation/set_clinic_region_widget.dart';
import 'package:clinic/features/clinic/pages/creation/set_clinic_time_widget.dart';
import 'package:clinic/features/clinic/pages/creation/set_clinic_vezeeta_widget.dart';
import 'package:clinic/features/clinic/pages/creation/set_clinic_workdays_widget.dart';
import 'package:clinic/global/constants/clinic_page_mode.dart';
import 'package:flutter/material.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';

class CreateClinicPage extends StatelessWidget {
  final int index;
  final ClinicPageMode mode;
  const CreateClinicPage({
    super.key,
    required this.index,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(8)),
            child: Text(
              ' عيادة رقم ${index + 1}',
              style: const TextStyle(
                fontFamily: AppFonts.mainArabicFontFamily,
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          SetClinicGovernorateWidget(index: index, mode: mode),
          const SizedBox(height: 30),
          SetClinicRegionWidget(index: index, mode: mode),
          const SizedBox(height: 30),
          SetClinicLocationWidget(index: index, mode: mode),
          const SizedBox(height: 30),
          SetClinicWorkDaysWidget(index: index, mode: mode),
          const SizedBox(height: 30),
          SetClinicTimeWidget(index: index, mode: mode),
          const SizedBox(height: 30),
          SetClinicVezeetaWidget(index: index, mode: mode),
          const SizedBox(height: 40)
        ],
      ),
    );
  }
}
