import 'package:clinic/global/colors/app_colors.dart';
import 'package:flutter/material.dart';

class TopWidget extends StatelessWidget {
  const TopWidget({super.key, required this.icon, this.size = 70});
  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            spreadRadius: 0.7,
            blurRadius: 1,
            offset: Offset(0, 0.7),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          icon,
          color: Colors.white,
          shadows: const [
            BoxShadow(
              color: Colors.black38,
              spreadRadius: 0.5,
              blurRadius: 1,
              offset: Offset(0, 0.5),
            ),
          ],
          size: size,
        ),
      ),
    );
  }
}
