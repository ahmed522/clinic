import 'package:clinic/features/chat/controller/single_chat_page_controller.dart';
import 'package:clinic/features/medical_record/pages/user_medical_record_page.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:clinic/global/widgets/default_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MedicalRecordMessagePage extends StatelessWidget {
  const MedicalRecordMessagePage({
    super.key,
    required this.chatterId,
  });
  final String chatterId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(
        title: 'السجل الطبي',
      ),
      body: GetX<SingleChatPageController>(
        tag: chatterId,
        builder: (controller) {
          if (controller.messageLoading.isTrue) {
            return const Center(
              child: AppCircularProgressIndicator(height: 100, width: 100),
            );
          }
          return UserMedicalRecordPage(isMessage: true, chatterId: chatterId);
        },
      ),
    );
  }
}
