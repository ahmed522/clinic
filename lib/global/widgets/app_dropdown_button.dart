import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:flutter/material.dart';

class AppDropdownButton extends StatelessWidget {
  const AppDropdownButton({
    Key? key,
    required this.items,
    required this.onChanged,
    required this.value,
  }) : super(key: key);

  final List<String> items;
  final void Function(String? item) onChanged;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      items: items
          .map(
            (governorate) => DropdownMenuItem(
              value: governorate,
              child: Text(
                governorate,
                style:
                    const TextStyle(fontFamily: AppFonts.mainArabicFontFamily),
              ),
            ),
          )
          .toList(),
      onChanged: (item) => onChanged(item),
      value: value,
    );
  }
}
