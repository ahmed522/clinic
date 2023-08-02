import 'package:clinic/features/time_line/model/doctor_post_model.dart';
import 'package:clinic/features/time_line/pages/post/doctor_post/present_selected_clinics_widget.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:flutter/material.dart';

class PresentDiscountPostExtensionWidget extends StatelessWidget {
  const PresentDiscountPostExtensionWidget({
    Key? key,
    required this.post,
  }) : super(key: key);

  final DoctorPostModel post;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/img/gift.png',
              width: 80,
              height: 80,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              post.discount.toString(),
              style: const TextStyle(
                  color: AppColors.discountColor,
                  fontFamily: AppFonts.mainArabicFontFamily,
                  fontSize: 40,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        (post.selectedClinics == null || post.selectedClinics!.isEmpty)
            ? const SizedBox()
            : PresentSelectedClinicsWidget(post: post),
      ],
    );
  }
}
