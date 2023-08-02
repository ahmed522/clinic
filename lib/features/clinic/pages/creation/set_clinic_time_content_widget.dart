import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:flutter/material.dart';

class SetClinicTimeContentWidget extends StatelessWidget {
  const SetClinicTimeContentWidget({
    Key? key,
    this.onOpenTimeButtonPressed,
    this.onCloseTimeButtonPressed,
    required this.openTimeText,
    required this.closeTimeText,
  }) : super(key: key);

  final void Function()? onOpenTimeButtonPressed;
  final void Function()? onCloseTimeButtonPressed;
  final String openTimeText;
  final String closeTimeText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            TextButton(
              style: Theme.of(context).elevatedButtonTheme.style,
              onPressed: onOpenTimeButtonPressed,
              child: Text(
                openTimeText,
                style: TextStyle(
                  color: (Theme.of(context).brightness == Brightness.light)
                      ? AppColors.primaryColor
                      : Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 15),
            Text(
              'من',
              style: TextStyle(
                  fontFamily: AppFonts.mainArabicFontFamily,
                  color: (Theme.of(context).brightness == Brightness.light)
                      ? Colors.grey[850]
                      : Colors.white,
                  fontSize: 18),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            TextButton(
              style: Theme.of(context).elevatedButtonTheme.style,
              onPressed: onCloseTimeButtonPressed,
              child: Text(
                closeTimeText,
                style: TextStyle(
                  color: (Theme.of(context).brightness == Brightness.light)
                      ? AppColors.primaryColor
                      : Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 15),
            Text(
              'إلى',
              style: TextStyle(
                  fontFamily: AppFonts.mainArabicFontFamily,
                  color: (Theme.of(context).brightness == Brightness.light)
                      ? AppColors.darkThemeBackgroundColor
                      : Colors.white,
                  fontSize: 18),
            ),
          ],
        ),
      ],
    );
  }
}
