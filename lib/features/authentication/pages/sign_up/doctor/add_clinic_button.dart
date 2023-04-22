import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonst.dart';
import 'package:flutter/material.dart';

class AddClinicButton extends StatelessWidget {
  const AddClinicButton({
    Key? key,
    required this.onAddClinic,
  }) : super(key: key);
  final void Function() onAddClinic;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      onPressed: () => onAddClinic(),
      child: Row(
        children: const [
          Icon(
            Icons.add,
            color: Colors.white,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            'إضافة عيادة',
            style: TextStyle(
                color: Colors.white,
                fontFamily: AppFonts.mainArabicFontFamily,
                fontWeight: FontWeight.w600,
                fontSize: 15),
          )
        ],
      ),
    );
  }
}