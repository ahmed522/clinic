import 'package:clinic/features/time_line/controller/create_doctor_post_controller.dart';
import 'package:clinic/features/time_line/model/doctor_post_type.dart';
import 'package:clinic/features/time_line/pages/post/doctor_post/discount_extension_widget.dart';
import 'package:clinic/features/time_line/pages/post/doctor_post/doctor_post_type_widget.dart';
import 'package:clinic/features/time_line/pages/post/doctor_post/new_clinic_extension_widget.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoctorPostTypeParentWidget extends StatelessWidget {
  const DoctorPostTypeParentWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateDoctorPostController>(builder: (controller) {
      if (controller.loading) {
        return const Center(
          child: AppCircularProgressIndicator(width: 50, height: 50),
        );
      }
      return Column(children: [
        const DoctorPostTypeWidget(),
        const SizedBox(height: 30),
        (controller.postModel.postType == DoctorPostType.discount)
            ? DiscountExtensionWidget(discount: controller.postModel.discount!)
            : (controller.postModel.postType == DoctorPostType.newClinic)
                ? const NewClinicExtensionWidget()
                : const SizedBox(),
      ]);
    });
  }
}
