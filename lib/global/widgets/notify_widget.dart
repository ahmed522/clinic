import 'package:flutter/material.dart';

class NotifyWidget extends StatelessWidget {
  const NotifyWidget({
    Key? key,
    required this.size,
    required this.color,
    required this.shadowColor,
  }) : super(key: key);
  final double size;
  final Color color;
  final Color shadowColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            spreadRadius: 0.5,
            blurRadius: 1,
            offset: const Offset(0, 0.5),
          ),
        ],
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
