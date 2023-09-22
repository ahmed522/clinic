import 'package:clinic/features/clinic/controller/doctor_clinics_controller.dart';
import 'package:clinic/features/clinic/pages/common/day.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/features/clinic/model/clinic_model.dart';
import 'package:flutter/material.dart';

class ClinicWorkDaysWidget extends StatelessWidget {
  const ClinicWorkDaysWidget({
    Key? key,
    this.clinicIndex,
    this.isDoctorPost = false,
    this.clinicModel,
  }) : super(key: key);

  final int? clinicIndex;
  final bool isDoctorPost;
  final ClinicModel? clinicModel;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final ClinicModel clinic;
    if (isDoctorPost) {
      clinic = clinicModel!;
    } else {
      final controller = DoctorClinicsController.find;
      clinic = controller.clinics[clinicIndex!];
    }
    return Column(
      children: [
        Text(
          'أيام العمل',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        const SizedBox(
          height: 25,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            3,
            (index) => Day(
              day: AppConstants.weekDays[index + 4],
              size: (size.width < 330) ? 37 : 42,
              fontSize: (size.width < 330) ? 9 : 12,
              checked: clinic.workDays[AppConstants.weekDays[index + 4]]!,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            4,
            (index) => Day(
              day: AppConstants.weekDays[index],
              size: (size.width < 330) ? 37 : 42,
              fontSize: (size.width < 330) ? 9 : 12,
              checked: clinic.workDays[AppConstants.weekDays[index]]!,
            ),
          ),
        ),
      ],
    );
  }
}
