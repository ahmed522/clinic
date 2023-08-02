import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';

class ClinicLocationAndRegionWidget extends StatelessWidget {
  const ClinicLocationAndRegionWidget({
    Key? key,
    required this.region,
    required this.governorate,
  }) : super(key: key);

  final String region;
  final String governorate;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        size.width > 330
            ? Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: CommonFunctions.isLightMode(context)
                        ? AppColors.primaryColor
                        : Colors.white,
                    size: 45,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              )
            : const SizedBox(),
        Column(
          children: [
            Text(
              region,
              style: TextStyle(
                fontFamily: AppFonts.mainArabicFontFamily,
                color: CommonFunctions.isLightMode(context)
                    ? AppColors.primaryColor
                    : Colors.white,
                fontSize: (region.length > 20)
                    ? size.width > 330
                        ? 18
                        : 15
                    : 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              governorate,
              style: TextStyle(
                fontFamily: AppFonts.mainArabicFontFamily,
                color: CommonFunctions.isLightMode(context)
                    ? AppColors.primaryColor
                    : Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
