import 'package:clinic/features/clinic/controller/doctor_clinics_controller.dart';
import 'package:clinic/features/clinic/model/clinic_model.dart';
import 'package:clinic/features/clinic/pages/presentation/clinic_data_widget.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:clinic/global/widgets/default_appbar.dart';
import 'package:clinic/global/widgets/offline_page_builder.dart';
import 'package:flutter/material.dart';
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
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: DefaultAppBar(
        title: 'عيادة رقم ${clinicIndex + 1}',
      ),
      body: OfflinePageBuilder(
        child: GetX<DoctorClinicsController>(
          builder: (controller) {
            if (controller.loading.isTrue) {
              return SizedBox(
                height: size.height,
                child: const Center(
                  child: AppCircularProgressIndicator(
                    width: 100,
                    height: 100,
                  ),
                ),
              );
            }
            return ClinicDataWidget(
              clinicIndex: clinicIndex,
              clinic: clinic,
              isCurrentDoctorProfile: isCurrentUser,
              doctorId: controller.doctorId,
            );
          },
        ),
      ),
    );
  }
}
