import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';

class DoctorSpecializationWidget extends StatelessWidget {
  const DoctorSpecializationWidget({
    Key? key,
    required this.specialization,
  }) : super(key: key);

  final String specialization;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        (CommonFunctions.isLightMode(context))
            ? CachedNetworkImage(
                imageUrl: AppConstants.specializationsIcons[specialization]!,
                width: (size.width > 330) ? 40 : 25,
                height: (size.width > 330) ? 40 : 25,
                placeholder: (context, url) => const SizedBox(),
              )
            : ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcATop,
                ),
                child: CachedNetworkImage(
                  imageUrl: AppConstants.specializationsIcons[specialization]!,
                  width: (size.width > 330) ? 40 : 25,
                  height: (size.width > 330) ? 40 : 25,
                  placeholder: (context, url) => const SizedBox(),
                ),
              ),
        const SizedBox(width: 8),
        Text(
          specialization,
          style: TextStyle(
            fontFamily: AppFonts.mainArabicFontFamily,
            fontWeight: FontWeight.w600,
            fontSize: (size.width > 330) ? 22 : 18,
            color: (CommonFunctions.isLightMode(context))
                ? AppColors.primaryColor
                : Colors.white,
          ),
        ),
      ],
    );
  }
}
