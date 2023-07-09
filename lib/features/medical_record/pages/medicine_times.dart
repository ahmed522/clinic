import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/circle_button.dart';
import 'package:flutter/material.dart';

class MedicineTimes extends StatelessWidget {
  const MedicineTimes({
    super.key,
    required this.times,
    required this.onIncreament,
    required this.onDecreament,
  });
  final int times;
  final void Function() onIncreament;
  final void Function() onDecreament;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleButton(
            icon: const Icon(Icons.add),
            onPressed: () => onIncreament(),
            backgroundColor: (CommonFunctions.isLightMode(context))
                ? AppColors.primaryColor
                : AppColors.darkThemeBackgroundColor,
          ),
          Text(
            times.toString(),
            style: TextStyle(
              color: (CommonFunctions.isLightMode(context))
                  ? AppColors.darkThemeBackgroundColor
                  : Colors.white,
              fontFamily: AppFonts.mainArabicFontFamily,
              fontSize: 17,
            ),
          ),
          CircleButton(
            icon: const Icon(Icons.remove),
            onPressed: () => onDecreament(),
            backgroundColor: (CommonFunctions.isLightMode(context))
                ? AppColors.primaryColor
                : AppColors.darkThemeBackgroundColor,
          ),
        ],
      ),
    );
  }
}
