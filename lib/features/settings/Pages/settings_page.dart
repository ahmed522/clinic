import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:clinic/global/widgets/offline_page_builder.dart';
import 'package:clinic/global/widgets/page_top_widget_with_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          OfflinePageBuilder(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height / 5 + 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      title: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'تسجيل الخروج',
                          style: TextStyle(
                            color: CommonFunctions.isLightMode(context)
                                ? AppColors.darkThemeBackgroundColor
                                : Colors.white,
                            fontFamily: AppFonts.mainArabicFontFamily,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      trailing: Icon(
                        Icons.logout_rounded,
                        color: CommonFunctions.isLightMode(context)
                            ? AppColors.darkThemeBackgroundColor
                            : Colors.white,
                      ),
                      onTap: () => MyAlertDialog.showAlertDialog(
                        context,
                        'تسجيل الخروج',
                        'هل انت متأكد من تسجيل الخروج؟',
                        MyAlertDialog.getAlertDialogActions(
                          {
                            'نعم': () async {
                              try {
                                AuthenticationController.find.logout();
                              } catch (e) {
                                Get.back();
                                CommonFunctions.errorHappened();
                              }
                            },
                            'إلغاء': () => Get.back(),
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const TopPageWidgetWithText(
            text: 'الإعدادات',
            fontSize: 40,
          ),
        ],
      ),
    );
  }
}
