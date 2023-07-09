import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';

class CircularIconButton extends StatelessWidget {
  final bool selected;
  final Widget child;
  final void Function() onPressed;
  const CircularIconButton({
    required this.child,
    required this.onPressed,
    super.key,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: selected
            ? AppColors.primaryColor
            : (CommonFunctions.isLightMode(context))
                ? Colors.white
                : AppColors.darkThemeBackgroundColor,
        border: Border.all(
            color: selected
                ? AppColors.primaryColor
                : (CommonFunctions.isLightMode(context))
                    ? AppColors.primaryColor
                    : Colors.white,
            width: 2),
        shape: BoxShape.circle,
      ),
      child: SizedBox(
        height: 50.0,
        width: 50.0,
        child: Center(
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: onPressed,
            iconSize: 50.0,
            icon: child,
            color: selected
                ? Colors.white
                : (CommonFunctions.isLightMode(context))
                    ? AppColors.primaryColor
                    : Colors.white,
          ),
        ),
      ),
    );
  }
}
