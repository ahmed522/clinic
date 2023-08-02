import 'package:clinic/features/medical_record/controller/add_medical_record_controller.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:clinic/presentation/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateorEditMedicalRecordButton extends StatelessWidget {
  const CreateorEditMedicalRecordButton({
    Key? key,
    this.editPage = false,
  }) : super(key: key);
  final bool editPage;
  @override
  Widget build(BuildContext context) {
    return GetX<AddMedicalRecordController>(builder: (controller) {
      return ElevatedButton(
        onPressed: (controller.loading.isTrue)
            ? null
            : () async {
                controller.updateMedicalRecordInfo();
                await controller.createMedicalRecord(editPage);
                Get.until(
                  ModalRoute.withName(MainPage.route),
                );
              },
        style: ElevatedButton.styleFrom(
          elevation: 7.0,
          padding: const EdgeInsets.all(15.0),
          side: BorderSide(
            width: .1,
            color: (CommonFunctions.isLightMode(context))
                ? AppColors.primaryColor
                : Colors.white,
          ),
        ),
        child: (controller.loading.isTrue)
            ? const AppCircularProgressIndicator(
                width: 40,
                height: 40,
              )
            : Text(
                editPage ? 'تعديل السجل المرضي' : 'إنشاء السجل المرضي',
                style: Theme.of(context).textTheme.bodyText1,
              ),
      );
    });
  }
}
