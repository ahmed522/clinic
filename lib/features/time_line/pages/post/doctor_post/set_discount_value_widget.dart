import 'package:clinic/features/time_line/controller/create_doctor_post_controller.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/circle_button.dart';
import 'package:flutter/material.dart';

class SetDiscountValueWidget extends StatelessWidget {
  const SetDiscountValueWidget({
    Key? key,
    required this.discount,
  }) : super(key: key);

  final int discount;

  @override
  Widget build(BuildContext context) {
    final controller = CreateDoctorPostController.find;

    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'قيمة التخفيض',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleButton(
              onPressed: () => controller.incrementDiscount(),
              backgroundColor: (CommonFunctions.isLightMode(context))
                  ? AppColors.primaryColor
                  : Colors.black,
              child: const Icon(Icons.add),
            ),
            Text(
              '% $discount',
              style: TextStyle(
                color: (CommonFunctions.isLightMode(context))
                    ? AppColors.darkThemeBackgroundColor
                    : Colors.white,
                fontFamily: AppFonts.mainArabicFontFamily,
                fontSize: 20,
              ),
            ),
            CircleButton(
              onPressed: () => controller.decrementDiscount(),
              backgroundColor: (CommonFunctions.isLightMode(context))
                  ? AppColors.primaryColor
                  : Colors.black,
              child: const Icon(Icons.remove),
            ),
          ],
        ),
      ],
    );
  }
}
