import 'package:clinic/presentation/widgets/bottom_navigation_bar/bottom_navigation_bar_path.dart';
import 'package:flutter/material.dart';

class BottomNavBarCustomPainterBorder extends CustomPainter {
  late final Color color;
  BottomNavBarCustomPainterBorder({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.2;
    Path path = BottomNavBarPath.getBottomNavBarPath(size);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
