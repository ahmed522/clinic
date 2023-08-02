import 'package:clinic/features/time_line/model/doctor_post_model.dart';
import 'package:clinic/features/time_line/pages/post/doctor_post/present_selected_clinics_widget.dart';
import 'package:flutter/material.dart';

class PresentNewClinicPostExtensionWidget extends StatelessWidget {
  const PresentNewClinicPostExtensionWidget({
    Key? key,
    required this.post,
  }) : super(key: key);

  final DoctorPostModel post;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/img/new-clinic.png',
          width: 80,
          height: 80,
        ),
        const SizedBox(
          height: 15,
        ),
        (post.selectedClinics == null || post.selectedClinics!.isEmpty)
            ? const SizedBox()
            : PresentSelectedClinicsWidget(
                post: post,
                isNewClinicPost: true,
              ),
      ],
    );
  }
}
