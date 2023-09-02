import 'package:clinic/features/medical_record/controller/medical_record_page_controller.dart';
import 'package:clinic/features/medical_record/pages/medical_record_is_not_set.dart';
import 'package:clinic/features/medical_record/pages/user_medical_record_page.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:clinic/global/widgets/appbar_widget.dart';
import 'package:clinic/global/widgets/error_page.dart';
import 'package:clinic/global/widgets/offline_page_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MedicalRecordPage extends StatelessWidget {
  const MedicalRecordPage({super.key});
  static const String route = '/medicalRecordPageRoute';

  @override
  Widget build(BuildContext context) {
    Get.put(MedicalRecordPageController());
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.height / 6),
        child: const AppBarWidget(text: '        السجل المرضي'),
      ),
      body: OfflinePageBuilder(
        child: GetBuilder<MedicalRecordPageController>(
          builder: (controller) {
            if (controller.errorHappend) {
              return const ErrorPage(
                imageAsset: 'assets/img/error.svg',
                message: '  حدثت مشكلة، يرجى إعادة المحاولة لاحقاً',
              );
            }
            if (controller.loading) {
              return const Center(
                child: AppCircularProgressIndicator(
                  width: 100,
                  height: 100,
                ),
              );
            }
            if (controller.medicalRecordIsSet) {
              try {
                return const UserMedicalRecordPage();
              } catch (e) {
                return const ErrorPage(
                  imageAsset: 'assets/img/error.svg',
                  message: '  حدثت مشكلة، يرجى إعادة المحاولة لاحقاً',
                );
              }
            }
            return const MedicalRecordIsNotSet();
          },
        ),
      ),
    );
  }
}
