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
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: SizedBox(
        width: 35,
        height: 35,
        child: Center(
          child: IconButton(
            padding: EdgeInsets.zero,
            iconSize: 20,
            icon: icon,
            onPressed: onPressed,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
