import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:flutter/material.dart';

class ClinicUseCurrentLocationButton extends StatelessWidget {
  const ClinicUseCurrentLocationButton({
    Key? key,
    this.onPressed,
    required this.clinicLocationLoading,
  }) : super(key: key);

  final void Function()? onPressed;
  final bool clinicLocationLoading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: Theme.of(context).elevatedButtonTheme.style,
      onPressed: onPressed,
      child: Row(
        children: [
          clinicLocationLoading
              ? const AppCircularProgressIndicator(
                  width: 20,
                  height: 20,
                )
              : Icon(
                  Icons.location_on_outlined,
                  color: (CommonFunctions.isLightMode(context))
                      ? AppColors.darkThemeBackgroundColor
                      : Colors.white,
                  size: 20,
                ),
          const SizedBox(
            width: 5,
          ),
          Text(
            'إستخدم الموقع الحالي',
            style: TextStyle(
              color: (CommonFunctions.isLightMode(context))
                  ? AppColors.darkThemeBackgroundColor
                  : Colors.white,
              fontFamily: AppFonts.mainArabicFontFamily,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
