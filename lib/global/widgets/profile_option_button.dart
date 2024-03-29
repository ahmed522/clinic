import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/notify_widget.dart';
import 'package:flutter/material.dart';

class ProfileOptionButton extends StatelessWidget {
  const ProfileOptionButton({
    Key? key,
    required this.text,
    required this.imageAsset,
    required this.onPressed,
    this.notify = false,
    this.topPadding = 25,
  }) : super(key: key);
  final String text;
  final String imageAsset;
  final void Function()? onPressed;
  final bool notify;
  final double topPadding;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(top: topPadding, left: 25.0, right: 25.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: (CommonFunctions.isLightMode(context))
              ? Colors.white
              : AppColors.darkThemeBottomNavBarColor,
          elevation: 4,
          side: const BorderSide(style: BorderStyle.none),
          padding: const EdgeInsets.all(25.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              children: [
                Image.asset(
                  imageAsset,
                  width: 50,
                  height: 50,
                ),
                notify
                    ? const NotifyWidget(
                        size: 14,
                        color: Colors.red,
                        shadowColor: Colors.redAccent,
                      )
                    : const SizedBox(),
              ],
            ),
            Text(
              text,
              style: TextStyle(
                color: (CommonFunctions.isLightMode(context))
                    ? AppColors.primaryColor
                    : Colors.white,
                fontSize: (text.length > 15 && size.width < 300) ? 17 : 20,
                fontFamily: AppFonts.mainArabicFontFamily,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}
