import 'package:clinic/global/colors/app_colors.dart';
import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  const CircleButton(
      {super.key,
      this.backgroundColor = AppColors.primaryColor,
      required this.icon,
      required this.onPressed});

  final Color backgroundColor;
  final Icon icon;
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            elevation: 7,
            backgroundColor: backgroundColor,
            foregroundColor: Colors.white,
            shape: const CircleBorder()),
        child: icon);
  }
}
