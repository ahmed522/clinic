import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:flutter/material.dart';

class PostSideInfo extends StatelessWidget {
  const PostSideInfo({
    Key? key,
    required this.text,
    required this.textColor,
    required this.imageAsset,
  }) : super(key: key);
  final String text;
  final Color textColor;
  final String imageAsset;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Image.asset(imageAsset, width: 30),
        const SizedBox(
          width: 3.0,
        ),
        Text(
          text,
          style: TextStyle(
            fontFamily: AppFonts.mainArabicFontFamily,
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
