import 'package:clinic/features/doctor_profile/controller/doctor_profile_page_controller.dart';
import 'package:clinic/features/doctor_profile/pages/doctor_degree_widget.dart';
import 'package:clinic/features/doctor_profile/pages/doctor_social_data_widget.dart';
import 'package:clinic/features/doctor_profile/pages/doctor_specialization_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoctorDataWidget extends StatelessWidget {
  const DoctorDataWidget({super.key, required this.doctorId});
  final String doctorId;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final DoctorProfilePageController controller = Get.find(tag: doctorId);
    return SizedBox(
      width: size.width,
      child: Column(
        children: [
          DoctorSpecializationWidget(
              specialization: controller.currentDoctor.specialization),
          const SizedBox(height: 5),
          DoctorDegreeWidget(degree: controller.currentDoctor.degree),
          const SizedBox(height: 30),
          DoctorSocialDataWidget(
            numberOfFollowing: controller.currentDoctor.numberOfFollowing,
            numberOfFollowers: controller.currentDoctor.numberOfFollowers,
            numberOfPosts: controller.currentDoctor.numberOfPosts,
          )
        ],
      ),
    );
  }
}
