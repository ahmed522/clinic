import 'package:clinic/features/authentication/controller/sign_up/common/signup_controller.dart';
import 'package:clinic/features/authentication/pages/sign_up/doctor/doctor_signup_parent.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RemoveClinicButton extends StatelessWidget {
  const RemoveClinicButton({
    Key? key,
    required this.onRemoveClinic,
  }) : super(key: key);
  final void Function() onRemoveClinic;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final SignupController controller =
        Get.find<SignupController>(tag: DoctorSignUpParent.route);
    return ElevatedButton(
      style: Theme.of(context).elevatedButtonTheme.style,
      onPressed: controller.loading
          ? null
          : () {
              MyAlertDialog.showAlertDialog(
                  context,
                  'هل أنت متأكد من إزالة العيادة ؟',
                  null,
                  MyAlertDialog.getAlertDialogActions({
                    'متأكد': () {
                      onRemoveClinic();
                      Get.back();
                    },
                    'إلغاء': () => Get.back(),
                  }));
            },
      child: Row(
        children: [
          Icon(
            Icons.remove,
            color: (CommonFunctions.isLightMode(context))
                ? AppColors.primaryColor
                : Colors.white,
          ),
          SizedBox(
            width: (size.width > 320) ? 5 : 0,
          ),
          (size.width > 320)
              ? Text(
                  'إزالة عيادة',
                  style: TextStyle(
                    color: (CommonFunctions.isLightMode(context))
                        ? AppColors.primaryColor
                        : Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.mainArabicFontFamily,
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
