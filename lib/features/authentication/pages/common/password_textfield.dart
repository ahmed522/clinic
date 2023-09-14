import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:flutter/material.dart';

class PasswordTextField extends StatelessWidget {
  const PasswordTextField({
    Key? key,
    required this.showPassword,
    required this.validator,
    required this.onShowPasswordButtonPressed,
  }) : super(key: key);
  final bool showPassword;
  final String? Function(String? value) validator;
  final void Function() onShowPasswordButtonPressed;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) => validator(value),
      keyboardType: TextInputType.visiblePassword,
      enableSuggestions: false,
      autocorrect: false,
      obscureText: !showPassword,
      decoration: InputDecoration(
        labelText: 'كلمة المرور',
        icon: const Icon(Icons.password_rounded),
        hintText: 'أدخل كلمة المرور',
        suffixIcon: IconButton(
          icon: (showPassword)
              ? const Icon(Icons.visibility)
              : const Icon(Icons.visibility_off),
          onPressed: () => onShowPasswordButtonPressed(),
        ),
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
