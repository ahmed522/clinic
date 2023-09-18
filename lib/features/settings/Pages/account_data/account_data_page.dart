import 'package:clinic/features/settings/Pages/common/single_setting.dart';
import 'package:clinic/features/settings/Pages/common/switch_setting_item.dart';
import 'package:clinic/features/settings/controller/account_data_page_controller.dart';
import 'package:clinic/features/settings/controller/settings_on_pressed_functions.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/default_appbar.dart';
import 'package:clinic/global/widgets/offline_page_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountDataPage extends StatelessWidget {
  const AccountDataPage({super.key});
  @override
  Widget build(BuildContext context) {
    if (CommonFunctions.currentUserType == UserType.doctor) {
      Get.put(AccountDataPageController());
    }
    return Scaffold(
      appBar: const DefaultAppBar(
        title: 'بيانات الحساب',
      ),
      body: OfflinePageBuilder(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SingleSetting(
                        text: 'كلمة المرور',
                        icon: Icons.password_rounded,
                        onPressed: () => SettingsOnPressedFunctions
                            .onChangePasswordSettingPressed(),
                      ),
                      (CommonFunctions.currentUserType == UserType.doctor)
                          ? SingleSetting(
                              text: 'الدرجة العلمية',
                              icon: Icons.school_rounded,
                              onPressed: () => SettingsOnPressedFunctions
                                  .onChangeDegreeSettingPressed(),
                            )
                          : const SizedBox(),
                      (CommonFunctions.currentUserType == UserType.doctor)
                          ? GetBuilder<AccountDataPageController>(
                              builder: (controller) {
                                return SwitchSettingItem(
                                  text: 'الإشعار بحالات الطوارئ',
                                  icon: Icons.circle_notifications_outlined,
                                  switchOn: controller.ergentCasesNotifications,
                                  onSwitchChange: (value) => controller
                                      .updateErgentCasesNotifications(value),
                                );
                              },
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
