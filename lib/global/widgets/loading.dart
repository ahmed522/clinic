import 'package:clinic/global/colors/app_colors.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  static const route = '/LoadingPage';

  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : Colors.grey[850],
      child: Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).brightness == Brightness.light
              ? AppColors.primaryColor
              : Colors.white,
        ),
      ),
    );
  }
}
