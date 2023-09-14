import 'package:clinic/features/clinic/model/clinic_model.dart';
import 'package:clinic/features/clinic/pages/presentation/clinic_location_widget.dart';
import 'package:clinic/features/clinic/pages/presentation/clinic_time_widget.dart';
import 'package:clinic/features/clinic/pages/presentation/clinic_vezeeta_widget.dart';
import 'package:clinic/features/clinic/pages/presentation/clinic_workdays_widget.dart';
import 'package:clinic/features/clinic/pages/presentation/edit_clinic_button.dart';
import 'package:clinic/features/clinic/pages/presentation/edit_clinic_page.dart';
import 'package:clinic/features/clinic/pages/presentation/remove_clinic_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClinicDataWidget extends StatelessWidget {
  const ClinicDataWidget({
    Key? key,
    required this.clinicIndex,
    this.isDoctorPost = false,
    this.clinic,
    required this.isCurrentDoctorProfile,
    required this.doctorId,
  }) : super(key: key);

  final int clinicIndex;
  final bool isDoctorPost;
  final bool isCurrentDoctorProfile;
  final ClinicModel? clinic;
  final String doctorId;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            ClinicLocationWidget(
              clinicIndex: clinicIndex,
              isDoctorPost: isDoctorPost,
              clinicModel: clinic,
            ),
            const SizedBox(height: 30),
            ClinicWorkDaysWidget(
              clinicIndex: clinicIndex,
              isDoctorPost: isDoctorPost,
              clinicModel: clinic,
            ),
            const SizedBox(height: 30),
            ClinicWorkTimeWidget(
              clinicIndex: clinicIndex,
              isDoctorPost: isDoctorPost,
              clinicModel: clinic,
            ),
            const SizedBox(height: 30),
            ClinicVezeetaWidget(
              clinicIndex: clinicIndex,
              isDoctorPost: isDoctorPost,
              clinicModel: clinic,
            ),
            const SizedBox(height: 40),
            isDoctorPost || !isCurrentDoctorProfile
                ? const SizedBox()
                : Column(
                    children: [
                      EditClinicButton(
                        onPressed: () => Get.to(
                          () => EditClinicPage(
                            clinicIndex: clinicIndex,
                            doctorId: doctorId,
                          ),
                          transition: Transition.rightToLeftWithFade,
                        ),
                      ),
                      const SizedBox(height: 5),
                      RemoveClinicButton(
                        clinicIndex: clinicIndex,
                        clinicId: clinic!.clinicId!,
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
