import 'package:clinic/features/medical_record/controller/medical_record_page_controller.dart';
import 'package:clinic/features/medical_record/pages/medical_record_is_not_set.dart';
import 'package:clinic/features/medical_record/pages/user_medical_record_page.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:clinic/global/widgets/error_page.dart';
import 'package:clinic/global/widgets/page_top_widget_with_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MedicalRecordPage extends StatelessWidget {
  MedicalRecordPage({super.key});
  static const String route = '/medicalRecordPageRoute';
  final controller = Get.put(MedicalRecordPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GetBuilder<MedicalRecordPageController>(
            builder: (controller) {
              if (controller.errorHappend) {
                return const ErrorPage(
                  imageAsset: 'assets/img/error.svg',
                  message: '  حدثت مشكلة، يرجى إعادة المحاولة لاحقاً',
                );
              }
              if (controller.loading) {
                return const Center(
                  child: AppCircularProgressIndicator(width: 100, height: 100),
                );
              }
              if (controller.medicalRecordIsSet) {
                return const UserMedicalRecordPage();
              }
              return const MedicalRecordIsNotSet();
            },
          ),
          const TopPageWidgetWithText(
            text: 'السجل المرضي',
            fontSize: 30,
          ),
        ],
      ),
    );
  }
}
