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
    final size = MediaQuery.of(context).size;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Image.asset(imageAsset, width: (size.width > 330) ? 30 : 24),
        SizedBox(
          width: (size.width > 330) ? 3.0 : 0.0,
        ),
        (size.width > 330)
            ? Text(
                text,
                style: TextStyle(
                  fontFamily: AppFonts.mainArabicFontFamily,
                  fontWeight: FontWeight.w700,
                  fontSize: (size.width > 330) ? 15 : 12,
                  color: textColor,
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
