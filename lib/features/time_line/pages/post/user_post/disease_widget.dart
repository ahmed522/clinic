import 'package:clinic/global/colors/app_colors.dart';
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
                color: (Theme.of(context).brightness == Brightness.light)
                    ? AppColors.primaryColor
                    : Colors.white,
              ),
            ),
            backgroundColor: (Theme.of(context).brightness == Brightness.light)
                ? Colors.white
                : AppColors.darkThemeBackgroundColor,
            foregroundColor: (Theme.of(context).brightness == Brightness.light)
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
