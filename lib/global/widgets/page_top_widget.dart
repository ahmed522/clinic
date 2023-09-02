import 'package:clinic/global/widgets/profile_page_clipper.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopPageWidget extends StatelessWidget {
  const TopPageWidget({
    Key? key,
    required this.height,
  }) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        SizedBox(
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
        ),
        Navigator.canPop(context)
            ? Positioned(
                top: size.height / 12,
                right: 20,
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(
                    Icons.arrow_circle_right_outlined,
                    size: 40,
                    shadows: [
                      BoxShadow(
                        color: Colors.black38,
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 1.5),
                      ),
                    ],
                    color: Colors.white,
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
