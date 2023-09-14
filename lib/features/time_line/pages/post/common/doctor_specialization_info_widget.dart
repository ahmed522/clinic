import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';

class DoctorSpecializationInfoWidget extends StatelessWidget {
  const DoctorSpecializationInfoWidget({
    Key? key,
    required this.specialization,
    this.isFollowerCard = false,
  }) : super(key: key);

  final String specialization;
  final bool isFollowerCard;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: (CommonFunctions.isLightMode(context))
                ? AppColors.primaryColor
                : Colors.white,
          ),
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          (size.width > 330 || isFollowerCard)
              ? (Theme.of(context).brightness == Brightness.dark)
                  ? ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcATop,
                      ),
                      child: Image.asset(
                        AppConstants.specializationsIcons[specialization]!,
                        width: (size.width > 330) ? 20 : 15,
                        height: (size.width > 330) ? 20 : 15,
                      ),
                    )
                  : Image.asset(
                      AppConstants.specializationsIcons[specialization]!,
                      width: (size.width > 330) ? 20 : 15,
                      height: (size.width > 330) ? 20 : 15,
                    )
              : const SizedBox(),
          SizedBox(width: (size.width > 330 || isFollowerCard) ? 3 : 0),
          Text(
            specialization,
            style: TextStyle(
              fontFamily: AppFonts.mainArabicFontFamily,
              fontWeight: FontWeight.w600,
              fontSize: (size.width > 330 || isFollowerCard) ? 12 : 8,
              color: (CommonFunctions.isLightMode(context))
                  ? AppColors.primaryColor
                  : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
