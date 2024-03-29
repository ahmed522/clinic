import 'package:flutter/material.dart';

class TimeLinePageClipper extends ContinuousRectangleBorder {
  const TimeLinePageClipper({required this.height});

  final double height;

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) => Path()
    ..lineTo(0, rect.size.height)
    ..quadraticBezierTo(rect.size.width / 2, rect.size.height + height * 2,
        rect.size.width, rect.size.height)
    ..lineTo(rect.size.width, 0)
    ..close();
}
