import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:flutter/material.dart';

class AddClinicsWidget extends StatelessWidget {
  const AddClinicsWidget({
    Key? key,
    required this.onAddClinicPressed,
    required this.title,
  }) : super(key: key);
  final Future<void> Function() onAddClinicPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () => onAddClinicPressed(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                SizedBox(
                  width: (size.width > 320) ? 5 : 0,
                ),
                (size.width > 320)
                    ? const Text(
                        'إضافة عيادة',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: AppFonts.mainArabicFontFamily,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
