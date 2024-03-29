import 'package:clinic/features/settings/Pages/common/single_setting.dart';
import 'package:clinic/features/settings/controller/settings_on_pressed_functions.dart';
import 'package:clinic/global/widgets/default_appbar.dart';
import 'package:clinic/global/widgets/offline_page_builder.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(title: 'الإعدادات'),
      body: OfflinePageBuilder(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20, top: 10),
                child: Column(
                  children: [
                    SingleSetting(
                      text: 'بيانات الحساب',
                      icon: Icons.account_circle_outlined,
                      onPressed: () => SettingsOnPressedFunctions
                          .onAccountDataSettingPressed(),
                    ),
                    SingleSetting(
                      text: 'سجل النشاطات',
                      icon: Icons.manage_history_sharp,
                      onPressed: () => SettingsOnPressedFunctions
                          .onActivitiesHistorySettingPressed(),
                    ),
                    SingleSetting(
                      text: 'ماذا عنا',
                      icon: Icons.info_outline_rounded,
                      onPressed: () {},
                    ),
                    SingleSetting(
                      text: 'تواصل معنا',
                      icon: Icons.contact_mail_outlined,
                      onPressed: () => SettingsOnPressedFunctions
                          .onContactUsSettingPressed(),
                    ),
                    SingleSetting(
                      text: 'مشاركة طبيب',
                      icon: Icons.share_rounded,
                      onPressed: () {},
                    ),
                    SingleSetting(
                      text: 'تسجيل الخروج',
                      icon: Icons.logout_rounded,
                      onPressed: () =>
                          SettingsOnPressedFunctions.onSingOutSettingPressed(
                        context,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
