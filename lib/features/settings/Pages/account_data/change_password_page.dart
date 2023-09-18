import 'package:clinic/features/authentication/pages/common/password_textfield.dart';
import 'package:clinic/features/settings/Pages/account_data/top_widget.dart';
import 'package:clinic/features/settings/controller/change_password_page_controller.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:clinic/global/widgets/default_appbar.dart';
import 'package:clinic/global/widgets/offline_page_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangePasswordPageController());
    return Scaffold(
      appBar: const DefaultAppBar(
        title: 'تغيير كلمة المرور',
      ),
      body: OfflinePageBuilder(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 10.0,
              top: 60.0,
            ),
            child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  const TopWidget(icon: Icons.password_rounded),
                  const SizedBox(
                    height: 60,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'كلمة المرور القديمة',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  GetBuilder<ChangePasswordPageController>(
                    builder: (controller) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: PasswordTextField(
                          showPassword: controller.showOldPassword,
                          validator: (value) =>
                              controller.oldPasswordValidator(value),
                          onShowPasswordButtonPressed: () =>
                              controller.updateShowOldPassword(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MyAlertDialog.getInfoAlertDialog(
                        context,
                        'يجب أن تحتوي كلمة المرور على الاتي ',
                        AppConstants.passwordRequirements,
                        {
                          'أعي ذلك': () => Navigator.of(context).pop(),
                        },
                      ),
                      Text(
                        'كلمة المرور الجديدة',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                  GetBuilder<ChangePasswordPageController>(
                    builder: (controller) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: PasswordTextField(
                          showPassword: controller.showNewPassword,
                          validator: (value) =>
                              controller.newPasswordValidator(value),
                          onShowPasswordButtonPressed: () =>
                              controller.updateShowNewPassword(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 70),
                  GetBuilder<ChangePasswordPageController>(
                    builder: (controller) {
                      return ElevatedButton(
                        onPressed: controller.loading
                            ? null
                            : () => _onChangePasswordButtonPressed(context),
                        style: ElevatedButton.styleFrom(
                            disabledBackgroundColor: Colors.grey,
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                        child: controller.loading
                            ? const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: AppCircularProgressIndicator(
                                  width: 40,
                                  height: 40,
                                ),
                              )
                            : const Text(
                                'تغيير كلمة المرور',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: AppFonts.mainArabicFontFamily,
                                  color: Colors.white,
                                ),
                              ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _onChangePasswordButtonPressed(BuildContext context) {
    final controller = ChangePasswordPageController.find;
    if (controller.formKey.currentState!.validate()) {
      MyAlertDialog.showAlertDialog(
        context,
        'تغيير كلمة المرور',
        'هل انت متأكد من تغيير كلمة المرور؟',
        MyAlertDialog.getAlertDialogActions(
          {
            'العودة': () => Get.back(),
            'تغيير': () {
              controller.changePassword();
              Get.back();
            },
          },
        ),
      );
    }
  }
}
