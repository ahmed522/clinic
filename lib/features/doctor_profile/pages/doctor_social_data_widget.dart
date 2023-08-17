import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/widgets/present_number_widget.dart';
import 'package:flutter/material.dart';

class DoctorSocialDataWidget extends StatelessWidget {
  const DoctorSocialDataWidget({
    Key? key,
    required this.numberOfFollowers,
    required this.numberOfFollowing,
    required this.numberOfPosts,
  }) : super(key: key);

  final int numberOfFollowers;
  final int numberOfFollowing;
  final int numberOfPosts;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            PresentNumberWidget(number: numberOfFollowing, fontSize: 20),
            const Text(
              'المتابَعون',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.primaryColor,
                fontFamily: AppFonts.mainArabicFontFamily,
              ),
            ),
          ],
        ),
        Column(
          children: [
            PresentNumberWidget(number: numberOfFollowers, fontSize: 20),
            const Text(
              'المتابِعون',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.primaryColor,
                fontFamily: AppFonts.mainArabicFontFamily,
              ),
            ),
          ],
        ),
        Column(
          children: [
            PresentNumberWidget(number: numberOfPosts, fontSize: 20),
            const Text(
              'المشاركات',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.primaryColor,
                fontFamily: AppFonts.mainArabicFontFamily,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
