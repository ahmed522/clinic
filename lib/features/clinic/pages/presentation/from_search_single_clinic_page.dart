import 'package:clinic/features/clinic/controller/doctor_clinics_controller.dart';
import 'package:clinic/features/clinic/model/clinic_model.dart';
import 'package:clinic/features/clinic/pages/presentation/clinic_data_widget.dart';
import 'package:clinic/features/doctor_profile/pages/doctor_profile_page.dart';
import 'package:clinic/features/searching/controller/doctor_clinic_page_controller.dart';
import 'package:clinic/features/time_line/pages/post/common/user_name_and_pic_widget.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:clinic/global/widgets/default_appbar.dart';
import 'package:clinic/global/widgets/offline_page_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FromSearchSingleClinicPage extends StatelessWidget {
  const FromSearchSingleClinicPage({
    super.key,
    required this.clinic,
  });
  final ClinicModel clinic;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: DefaultAppBar(
        title:
            'عيادة ${(clinic.doctorGender == Gender.male) ? 'الطبيب' : 'الطبيبة'} ${clinic.doctorName!}',
      ),
      body: OfflinePageBuilder(
        child: GetX<DoctorClinicPageController>(
          init: DoctorClinicPageController(clinic),
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
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => Get.to(
                        () => DoctorProfilePage(
                          doctorId: clinic.doctorId!,
                          isCurrentUser:
                              CommonFunctions.isCurrentUser(clinic.doctorId!),
                        ),
                        transition: Transition.rightToLeftWithFade,
                      ),
                      child: UserNameAndPicWidget(
                        userName: clinic.doctorName!,
                        userPic: clinic.doctorPic,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ClinicDataWidget(
                      clinic: clinic,
                      isCurrentDoctorProfile:
                          CommonFunctions.isCurrentUser(clinic.doctorId!),
                      isDoctorPost: true,
                      doctorId: clinic.doctorId!,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
