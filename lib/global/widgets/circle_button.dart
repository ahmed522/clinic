import 'package:clinic/global/colors/app_colors.dart';
import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  const CircleButton({
    super.key,
    this.backgroundColor = AppColors.primaryColor,
    this.foregroundColor = Colors.white,
    required this.child,
    required this.onPressed,
  });

  final Color backgroundColor;
  final Color foregroundColor;
  final Widget child;
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          elevation: 7,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: const CircleBorder()),
      child: child,
    );
  }
}
