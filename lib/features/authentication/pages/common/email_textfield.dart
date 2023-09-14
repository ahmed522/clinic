import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:flutter/material.dart';

class EmailTextField extends StatelessWidget {
  const EmailTextField({
    Key? key,
    required this.validator,
  }) : super(key: key);

  final String? Function(String?) validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) => validator(value),
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'البريد الإلكتروني',
        icon: Icon(Icons.email_rounded),
        hintText: 'أدخل بريدك الإلكتروني',
        labelStyle: TextStyle(
          fontFamily: AppFonts.mainArabicFontFamily,
        ),
        hintStyle: TextStyle(
          fontFamily: AppFonts.mainArabicFontFamily,
        ),
        errorStyle: TextStyle(
          fontFamily: AppFonts.mainArabicFontFamily,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
