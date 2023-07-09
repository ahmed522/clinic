import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';

class DiseaseWidget extends StatelessWidget {
  final void Function(String diseaseName, Key? key)? onPressed;
  final String diseaseName;
  const DiseaseWidget({
    required super.key,
    required this.diseaseName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: () => onPressed!(diseaseName, super.key),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: (CommonFunctions.isLightMode(context))
                    ? AppColors.primaryColor
                    : Colors.white,
              ),
            ),
            backgroundColor: (CommonFunctions.isLightMode(context))
                ? Colors.white
                : AppColors.darkThemeBackgroundColor,
            foregroundColor: (CommonFunctions.isLightMode(context))
                ? AppColors.primaryColor
                : Colors.white,
          ),
          child: Text(
            diseaseName,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        const SizedBox(
          width: 5,
        )
      ],
    );
  }
}
