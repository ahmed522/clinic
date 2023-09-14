import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:flutter/material.dart';

class NameTextField extends StatelessWidget {
  const NameTextField({
    Key? key,
    required this.getName,
    required this.text,
  }) : super(key: key);
  final void Function(String validatedName) getName;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'من فضلك ادخل الاسم  ';
        } else if (value.contains(RegExp(AppConstants.nameValidationRegExp)) ||
            value.contains(RegExp(r'[\u0660-\u0669]'))) {
          return 'الاسم لا يجب ان يحتوي على أرقام أو رموز';
        }
        getName(value);
        return null;
      },
      decoration: InputDecoration(
        labelText: 'الإسم $text',
        icon: const Icon(Icons.person),
        hintText: 'أدخل الإسم $text',
        labelStyle: const TextStyle(
          fontFamily: AppFonts.mainArabicFontFamily,
        ),
        hintStyle: const TextStyle(
          fontFamily: AppFonts.mainArabicFontFamily,
        ),
        errorStyle: const TextStyle(
          fontFamily: AppFonts.mainArabicFontFamily,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
