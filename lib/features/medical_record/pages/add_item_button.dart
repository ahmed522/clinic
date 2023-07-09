import 'package:clinic/features/medical_record/controller/add_medical_record_controller.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddItemButton extends StatelessWidget {
  const AddItemButton({
    Key? key,
    required this.onAddItem,
  }) : super(key: key);
  final void Function() onAddItem;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GetX<AddMedicalRecordController>(builder: (controller) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
        ),
        onPressed: controller.loading.isTrue ? null : onAddItem,
        child: Row(
          children: [
            const Icon(
              Icons.add,
              color: Colors.white,
            ),
            SizedBox(
              width: (size.width > 320) ? 5 : 0,
            ),
            (size.width > 320)
                ? const Text(
                    'إضافة',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: AppFonts.mainArabicFontFamily,
                        fontWeight: FontWeight.w600,
                        fontSize: 12),
                  )
                : const SizedBox(),
          ],
        ),
      );
    });
  }
}
