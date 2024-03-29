import 'package:clinic/features/medical_record/pages/add_medical_record.dart';
import 'package:clinic/global/widgets/profile_option_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MedicalRecordIsNotSet extends StatelessWidget {
  const MedicalRecordIsNotSet({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/img/medical-record-not-set.svg',
              height: 280,
              width: 280,
            ),
            const SizedBox(
              height: 30,
            ),
            const Padding(
              padding: EdgeInsets.only(right: 80.0, left: 80.0),
              child: Text(
                'لا يوجد سجل مرضي حتى الان',
                textAlign: TextAlign.center,
              ),
            ),
            ProfileOptionButton(
              text: 'إنشاء السجل المرضي',
              imageAsset: 'assets/img/medical-record.png',
              onPressed: () => Get.to(
                () => const AddMedicalRecord(),
                transition: Transition.rightToLeftWithFade,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
