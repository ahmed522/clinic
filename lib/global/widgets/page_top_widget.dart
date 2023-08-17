import 'package:clinic/global/widgets/profile_page_clipper.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:flutter/material.dart';

class TopPageWidget extends StatelessWidget {
  const TopPageWidget({
    Key? key,
    required this.height,
  }) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ClipPath(
        clipper: ProfilePageClipper(),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryColorLight.withOpacity(0.8),
                AppColors.primaryColor,
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: const [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
      ),
    );
  }
}
