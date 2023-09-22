import 'package:clinic/features/clinic/controller/doctor_clinics_controller.dart';
import 'package:clinic/features/clinic/pages/presentation/add_clinic_button.dart';
import 'package:clinic/features/clinic/pages/creation/add_clinic_page.dart';
import 'package:clinic/features/clinic/pages/presentation/single_clinic_item.dart';
import 'package:clinic/features/clinic/pages/presentation/single_clinic_page.dart';
import 'package:clinic/global/widgets/profile_option_button.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:clinic/global/widgets/default_appbar.dart';
import 'package:clinic/global/widgets/offline_page_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ClinicsPage extends StatelessWidget {
  const ClinicsPage({super.key, required this.doctorId});
  final String doctorId;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final controller = Get.put(DoctorClinicsController(doctorId));
    return Scaffold(
      appBar: const DefaultAppBar(title: 'العيادات'),
      body: OfflinePageBuilder(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SingleChildScrollView(
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
                    } else if (controller.clinics.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: size.height / 5),
                          SvgPicture.asset(
                            'assets/img/empty.svg',
                            width: 200,
                            height: 200,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'لا يوجد عيادات',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ),
                        ],
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        children: List<SingleClinicItem>.generate(
                          controller.clinics.length,
                          (index) => SingleClinicItem(
                            clinic: controller.clinics[index],
                            onTap: () => Get.to(
                              () => SingleClinicPage(
                                clinicIndex: index,
                                clinic: controller.clinics[index],
                                isCurrentUser: controller
                                    .doctorProfilePageController
                                    .isCurrentDoctorProfile,
                              ),
                              transition: Transition.rightToLeftWithFade,
                            ),
                            title: 'عيادة رقم ${index + 1}',
                            gender: controller.doctorProfilePageController
                                .currentDoctor.gender,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 50),
              controller.doctorProfilePageController.isCurrentDoctorProfile
                  ? AddClinicButton(
                      onPressed: () => Get.to(
                        () => AddClinicPage(
                          clinicIndex: controller.clinics.length,
                        ),
                        transition: Transition.rightToLeftWithFade,
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
