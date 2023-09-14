import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:linkwell/linkwell.dart';

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
      child: Align(
        alignment: Alignment.centerRight,
        child: LinkWell(
          postContent,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontFamily: AppFonts.mainArabicFontFamily,
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: (CommonFunctions.isLightMode(context))
                ? Colors.black87
                : Colors.white,
          ),
          linkStyle: const TextStyle(
            fontFamily: AppFonts.mainArabicFontFamily,
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
