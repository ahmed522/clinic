import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';

class SingleDiseaseType extends StatelessWidget {
  const SingleDiseaseType({
    super.key,
    required this.diseaseName,
    required this.backgroundColor,
    required this.imageAsset,
    required this.onTap,
  });
  final String diseaseName;
  final Color backgroundColor;
  final String imageAsset;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => onTap(),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                imageAsset,
                width: 30,
                height: 30,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          diseaseName,
          style: TextStyle(
              color: (CommonFunctions.isLightMode(context))
                  ? Colors.black
                  : Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              fontFamily: AppFonts.mainArabicFontFamily),
        ),
      ],
    );
  }
}
