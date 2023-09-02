import 'package:flutter/material.dart';

class AppbarClipper extends ContinuousRectangleBorder {
  const AppbarClipper();

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) => Path()
    ..lineTo(0, rect.size.height / 2)
    ..cubicTo(
        rect.size.width / 4,
        3 * (rect.size.height / 2),
        3 * (rect.size.width / 4),
        (rect.size.height / 2),
        rect.size.width,
        rect.size.height * 0.9)
    ..lineTo(rect.size.width, 0)
    ..close();
}
