import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/notify_widget.dart';
import 'package:flutter/material.dart';

import '../../../global/fonts/app_fonts.dart';

class MainPageOptionWidget extends StatelessWidget {
  const MainPageOptionWidget({
    super.key,
    required this.onPressed,
    required this.selected,
    required this.optionName,
    required this.optionIcon,
    this.notify = false,
  });
  final void Function() onPressed;
  final bool selected;
  final String optionName;
  final IconData optionIcon;
  final bool notify;
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () => onPressed(),
      constraints: const BoxConstraints(minWidth: 50),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        children: [
          const SizedBox(height: 15),
          Padding(
            padding: selected
                ? const EdgeInsets.only(top: 3.0)
                : const EdgeInsets.all(0.0),
            child: Stack(
              children: [
                Icon(
                  optionIcon,
                  color: selected
                      ? AppColors.primaryColor
                      : (CommonFunctions.isLightMode(context))
                          ? Colors.black54
                          : Colors.white54,
                  size: 30,
                ),
                notify
                    ? const Positioned(
                        left: 3,
                        child: NotifyWidget(
                          size: 10,
                          color: Colors.red,
                          shadowColor: Colors.redAccent,
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
          const SizedBox(height: 3),
          Text(
            optionName,
            style: TextStyle(
              color: selected
                  ? AppColors.primaryColor
                  : (CommonFunctions.isLightMode(context))
                      ? Colors.black54
                      : Colors.white54,
              fontFamily: AppFonts.mainArabicFontFamily,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
