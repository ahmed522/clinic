import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';

class EditClinicButton extends StatelessWidget {
  const EditClinicButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        elevation: 7.0,
        padding: const EdgeInsets.all(15.0),
        side: BorderSide(
          width: .1,
          color: (CommonFunctions.isLightMode(context))
              ? AppColors.primaryColor
              : Colors.white,
        ),
      ),
      child: Text(
        'تعديل بيانات العيادة',
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}
