import 'package:clinic/global/colors/app_colors.dart';
import 'package:flutter/material.dart';

class CommentContainer extends StatelessWidget {
  const CommentContainer({
    Key? key,
    required this.child,
    required this.borderWidth,
  }) : super(key: key);

  final Widget child;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: (Theme.of(context).brightness == Brightness.light)
            ? Colors.white
            : AppColors.darkThemeBackgroundColor,
        border: Border.all(
          color: (Theme.of(context).brightness == Brightness.light)
              ? AppColors.primaryColor
              : Colors.white,
          width: borderWidth,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(5),
      width: size.width,
      child: child,
    );
  }
}
