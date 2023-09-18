import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';

class CardTextField extends StatelessWidget {
  const CardTextField({
    Key? key,
    this.controller,
    this.onChanged,
    required this.keyboardType,
    this.hintText,
  }) : super(key: key);
  final TextEditingController? controller;
  final void Function(String value)? onChanged;
  final String? hintText;
  final TextInputType keyboardType;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 3,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: CommonFunctions.isLightMode(context)
              ? Colors.white
              : AppColors.darkThemeBottomNavBarColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          contentPadding: const EdgeInsets.all(10.0),
        ),
        cursorHeight: 20,
        onChanged: onChanged != null ? (value) => onChanged!(value) : null,
        enabled: true,
        keyboardType: keyboardType,
      ),
    );
  }
}
