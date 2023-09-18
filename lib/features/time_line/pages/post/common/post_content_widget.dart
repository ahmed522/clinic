import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:dart_emoji/dart_emoji.dart';
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
          textAlign: EmojiUtil.hasOnlyEmojis(
            postContent,
            ignoreWhitespace: true,
          )
              ? postContent.length == 2
                  ? TextAlign.center
                  : TextAlign.right
              : TextAlign.right,
          style: TextStyle(
            fontFamily: AppFonts.mainArabicFontFamily,
            fontSize: EmojiUtil.hasOnlyEmojis(
              postContent,
              ignoreWhitespace: true,
            )
                ? postContent.length == 2
                    ? 50
                    : 20
                : AppConstants.emojiRegex.hasMatch(postContent)
                    ? 15
                    : 13,
            fontWeight: FontWeight.w400,
            color: (CommonFunctions.isLightMode(context))
                ? Colors.black87
                : Colors.white,
          ),
          linkStyle: const TextStyle(
            fontFamily: AppFonts.mainArabicFontFamily,
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
