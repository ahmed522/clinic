import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:flutter/material.dart';

class PostContentWidget extends StatelessWidget {
  const PostContentWidget({
    Key? key,
    required this.postContent,
  }) : super(key: key);

  final String postContent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Text(
        postContent,
        textAlign: TextAlign.end,
        style: TextStyle(
          fontFamily: AppFonts.mainArabicFontFamily,
          fontWeight: FontWeight.w400,
          fontSize: 15,
          color: (Theme.of(context).brightness == Brightness.light)
              ? Colors.black87
              : Colors.white,
        ),
      ),
    );
  }
}