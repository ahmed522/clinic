import 'package:clinic/features/clinic/controller/doctor_clinics_controller.dart';
import 'package:clinic/features/clinic/model/clinic_model.dart';
import 'package:clinic/features/clinic/pages/presentation/clinic_data_widget.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:clinic/global/widgets/page_top_widget_with_text.dart';
import 'package:get/get.dart';

class SingleClinicPage extends StatelessWidget {
  const SingleClinicPage({
    super.key,
    required this.clinicIndex,
    required this.clinic,
    required this.isCurrentUser,
  });
  final ClinicModel clinic;
  final int clinicIndex;
  final bool isCurrentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GetX<DoctorClinicsController>(builder: (controller) {
            if (controller.loading.isTrue) {
              return const Center(
                child: AppCircularProgressIndicator(width: 100, height: 100),
              );
            }
            return ClinicDataWidget(
              clinicIndex: clinicIndex,
              clinic: clinic,
              isCurrentDoctorProfile: isCurrentUser,
              doctorId: controller.doctorId,
            );
          }),
          TopPageWidgetWithText(
            text: 'عيادة رقم ${clinicIndex + 1}',
            fontSize: 35,
          ),
        ],
      ),
    );
  }
}
