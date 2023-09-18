import 'package:clinic/global/colors/app_colors.dart';
import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  const CircleButton({
    super.key,
    this.backgroundColor = AppColors.primaryColor,
    this.foregroundColor = Colors.white,
    this.shadowColor,
    required this.child,
    required this.onPressed,
    this.elevation = 5.0,
  });

  final Color backgroundColor;
  final Color foregroundColor;
  final Color? shadowColor;
  final Widget child;
  final double elevation;
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        elevation: elevation,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        shape: const CircleBorder(),
        shadowColor: shadowColor,
      ),
      child: child,
    );
  }
}
