import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:flutter/material.dart';

class PresentNewDegreePostExtensionWidget extends StatelessWidget {
  const PresentNewDegreePostExtensionWidget({
    Key? key,
    required this.degree,
  }) : super(key: key);
  final String degree;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/img/certification.png',
              width: 80,
              height: 80,
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: AppColors.newDegreeColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.newDegreeColor.withOpacity(0.6),
                        spreadRadius: 0.7,
                        blurRadius: 1,
                        offset: const Offset(0, 0.7),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      degree,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: AppFonts.mainArabicFontFamily,
                        fontSize: 17,
                        shadows: [
                          BoxShadow(
                            color: Colors.black26,
                            spreadRadius: 0.5,
                            blurRadius: 0.7,
                            offset: Offset(0, 0.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
