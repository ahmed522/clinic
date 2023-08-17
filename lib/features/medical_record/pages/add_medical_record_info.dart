import 'package:clinic/features/medical_record/controller/add_medical_record_controller.dart';
import 'package:flutter/material.dart';

class AddMedicalRecordInfo extends StatelessWidget {
  const AddMedicalRecordInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = AddMedicalRecordController.find;
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text('هل تريد إضافة أي معلومات أخرى؟',
              style: Theme.of(context).textTheme.bodyText1),
        ),
        const SizedBox(height: 20),
        TextField(
          controller:
              TextEditingController(text: controller.medicalRecord.moreInfo),
          autofocus: true,
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          maxLength: 250,
          maxLines: 5,
          onChanged: (medicalRecordInfo) =>
              controller.updateTempMedicalRecordInfo(medicalRecordInfo),
        ),
      ],
    );
  }
}
