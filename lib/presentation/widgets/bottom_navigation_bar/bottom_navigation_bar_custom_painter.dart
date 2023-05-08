import 'package:clinic/presentation/widgets/bottom_navigation_bar/bottom_navigation_bar_path.dart';
import 'package:flutter/material.dart';

class BottomNavBarCustomPainter extends CustomPainter {
  late final Color color;
  BottomNavBarCustomPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    Path path = BottomNavBarPath.getBottomNavBarPath(size);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
