import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageTimeWidget extends StatelessWidget {
  const MessageTimeWidget({
    Key? key,
    required this.messageTime,
  }) : super(key: key);
  final Timestamp messageTime;
  @override
  Widget build(BuildContext context) {
    return Text(
      CommonFunctions.getTime(messageTime),
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      style: TextStyle(
        color: CommonFunctions.isLightMode(context)
            ? Colors.black54
            : Colors.white70,
        fontFamily: AppFonts.mainArabicFontFamily,
        fontSize: 9,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
