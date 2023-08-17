import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';

class ClinicLocationTextField extends StatelessWidget {
  const ClinicLocationTextField({
    Key? key,
    this.initialText,
    required this.onChanged,
  }) : super(key: key);

  final String? initialText;
  final void Function(String value) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 80.0),
      child: TextField(
        controller: TextEditingController(text: initialText),
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        decoration: InputDecoration(
          icon: const Icon(
            Icons.location_on_outlined,
          ),
          helperText: 'ادخل عنوان العيادة بالتفصيل',
          helperStyle: TextStyle(
            color: (CommonFunctions.isLightMode(context))
                ? AppColors.darkThemeBackgroundColor
                : Colors.white,
            fontFamily: AppFonts.mainArabicFontFamily,
            fontWeight: FontWeight.w500,
            fontSize: 10,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onChanged: (value) => onChanged(value),
      ),
    );
  }
}
