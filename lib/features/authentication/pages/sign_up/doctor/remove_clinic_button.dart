import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:flutter/material.dart';

class RemoveClinicButton extends StatelessWidget {
  const RemoveClinicButton({
    Key? key,
    required this.onRemoveClinic,
  }) : super(key: key);
  final void Function() onRemoveClinic;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: Theme.of(context).elevatedButtonTheme.style,
      onPressed: () {
        MyAlertDialog.showAlertDialog(
            context,
            'هل أنت متأكد من إزالة العيادة ؟',
            null,
            MyAlertDialog.getAlertDialogActions({
              'متأكد': () {
                onRemoveClinic();
                Navigator.of(context).pop();
              },
              'إلغاء': () => Navigator.of(context).pop(),
            }));
      },
      child: Row(
        children: [
          Icon(
            Icons.remove,
            color: (Theme.of(context).brightness == Brightness.light)
                ? AppColors.primaryColor
                : Colors.white,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            'إزالة عيادة',
            style: Theme.of(context).textTheme.bodyText1,
          )
        ],
      ),
    );
  }
}
