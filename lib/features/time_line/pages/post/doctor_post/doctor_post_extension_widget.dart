import 'package:clinic/features/time_line/model/doctor_post_model.dart';
import 'package:clinic/features/time_line/model/doctor_post_type.dart';
import 'package:clinic/features/time_line/pages/post/doctor_post/present_discount_post_extension_widget.dart';
import 'package:clinic/features/time_line/pages/post/doctor_post/present_medical_info_post_extension_widget.dart';
import 'package:clinic/features/time_line/pages/post/doctor_post/present_new_clinic_post_extension_widget.dart';
import 'package:flutter/material.dart';

class DoctorPostExtensionWidget extends StatelessWidget {
  const DoctorPostExtensionWidget({super.key, required this.post});
  final DoctorPostModel post;
  @override
  Widget build(BuildContext context) {
    if (post.postType == DoctorPostType.discount) {
      return PresentDiscountPostExtensionWidget(post: post);
    } else if (post.postType == DoctorPostType.newClinic) {
      return PresentNewClinicPostExtensionWidget(post: post);
    } else if (post.postType == DoctorPostType.medicalInfo) {
      return const PresentMedicalInfoPostExtensionWidget();
    } else {
      return const SizedBox();
    }
  }
}
