import 'package:clinic/features/time_line/model/doctor_post_type.dart';
import 'package:clinic/features/time_line/pages/post/doctor_post/doctor_post_type_option_widget.dart';
import 'package:flutter/material.dart';

class DoctorPostTypeWidget extends StatelessWidget {
  const DoctorPostTypeWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        DoctorPostTypeOptionWidget(
          value: DoctorPostType.medicalInfo,
          text: 'معلومة طبية',
          iconAsset: 'assets/img/info.png',
        ),
        DoctorPostTypeOptionWidget(
          value: DoctorPostType.discount,
          text: 'تخفيض',
          iconAsset: 'assets/img/discount.png',
        ),
        DoctorPostTypeOptionWidget(
          value: DoctorPostType.newClinic,
          text: 'عيادة جديدة',
          iconAsset: 'assets/img/announcement.png',
        ),
        DoctorPostTypeOptionWidget(
          value: DoctorPostType.other,
          text: 'أخرى',
          iconAsset: 'assets/img/else.png',
        ),
      ],
    );
  }
}
