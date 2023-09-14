import 'package:clinic/features/clinic/controller/doctor_clinics_controller.dart';
import 'package:clinic/features/clinic/pages/presentation/add_clinic_button.dart';
import 'package:clinic/features/clinic/pages/presentation/add_clinic_page.dart';
import 'package:clinic/features/clinic/pages/presentation/single_clinic_page.dart';
import 'package:clinic/features/user_profile/pages/common/profile_option_button.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:clinic/global/widgets/appbar_widget.dart';
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.height / 6),
        child: const AppBarWidget(text: '        العيادات'),
      ),
      body: OfflinePageBuilder(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SingleChildScrollView(
                child: GetX<DoctorClinicsController>(builder: (controller) {
                  if (controller.loading.isTrue) {
                    return SizedBox(
                      height: 5 * size.height / 6,
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
                        ]);
                  }
                  return Column(
                    children: List<ProfileOptionButton>.generate(
                      controller.clinics.length,
                      (index) => ProfileOptionButton(
                        text: 'عيادة رقم ${index + 1}',
                        imageAsset: 'assets/img/clinic.png',
                        onPressed: () => Get.to(
                          () => SingleClinicPage(
                            clinicIndex: index,
                            clinic: controller.clinics[index],
                            isCurrentUser: controller
                                .doctorProfilePageController
                                .isCurrentDoctorProfile,
                          ),
                          transition: Transition.rightToLeftWithFade,
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 70),
              controller.doctorProfilePageController.isCurrentDoctorProfile
                  ? AddClinicButton(
                      onPressed: () => Get.to(
                        () => AddClinicPage(
                          clinicIndex: controller.clinics.length,
                          doctorId: doctorId,
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
