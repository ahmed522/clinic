import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinic/features/medical_record/pages/medical_record_page.dart';
import 'package:clinic/features/profile/controller/user_profile_controller.dart';
import 'package:clinic/features/profile/pages/common/profile_option_button.dart';
import 'package:clinic/features/profile/pages/user_questions_page.dart';
import 'package:clinic/features/settings/Pages/settings_page.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:clinic/global/widgets/page_top_widget.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UserProfileController());
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: GetX<UserProfileController>(
        builder: (controller) {
          if (controller.updateImageLoading.isTrue) {
            return const Center(
              child: AppCircularProgressIndicator(
                height: 100,
                width: 100,
              ),
            );
          } else {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: size.height / 4 + 80),
                      ProfileOptionButton(
                        text: 'الأسئلة',
                        imageAsset: 'assets/img/questions.png',
                        onPressed: () =>
                            Get.to(() => const UserQuestionsPage()),
                      ),
                      const ProfileOptionButton(
                        text: 'الأطباء المُتابعون',
                        imageAsset: 'assets/img/following-doctors.png',
                        onPressed: null,
                      ),
                      const ProfileOptionButton(
                        text: 'الدردشات',
                        imageAsset: 'assets/img/chats.png',
                        onPressed: null,
                      ),
                      ProfileOptionButton(
                        text: 'السجل المرضي',
                        imageAsset: 'assets/img/medical-record.png',
                        onPressed: () => Get.to(() => MedicalRecordPage()),
                      ),
                      ProfileOptionButton(
                        text: 'الإعدادات',
                        imageAsset: 'assets/img/settings.png',
                        onPressed: () => Get.to(() => const SettingsPage()),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height / 4 + 35,
                  child: Stack(
                    children: [
                      TopPageWidget(height: size.height / 4),
                      Positioned(
                        bottom: 0,
                        left: 15,
                        child: Column(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: (Theme.of(context).brightness ==
                                              Brightness.light)
                                          ? Colors.grey.shade100
                                          : AppColors.darkThemeBackgroundColor,
                                      width: 2)),
                              child: GestureDetector(
                                onTap: () =>
                                    onPersonalImageClicked(context, size),
                                child: (controller.currentUserPersonalImage ==
                                        null)
                                    ? CircleAvatar(
                                        backgroundImage: const AssetImage(
                                            'assets/img/user.png'),
                                        radius: 100,
                                        backgroundColor:
                                            (Theme.of(context).brightness ==
                                                    Brightness.light)
                                                ? Colors.grey.shade100
                                                : AppColors
                                                    .darkThemeBackgroundColor,
                                      )
                                    : CircleAvatar(
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                          controller.currentUserPersonalImage,
                                        ),
                                        radius: 100,
                                        backgroundColor:
                                            (Theme.of(context).brightness ==
                                                    Brightness.light)
                                                ? Colors.grey.shade100
                                                : AppColors
                                                    .darkThemeBackgroundColor,
                                      ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              controller.currentUserName,
                              style: TextStyle(
                                color: (Theme.of(context).brightness ==
                                        Brightness.dark)
                                    ? Colors.white
                                    : AppColors.darkThemeBackgroundColor,
                                fontFamily: AppFonts.mainArabicFontFamily,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  onPersonalImageClicked(BuildContext context, Size size) {
    final controller = UserProfileController.find;
    Get.bottomSheet(
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            (controller.currentUserPersonalImage == null)
                ? const SizedBox()
                : ListTile(
                    onTap: () => Get.dialog(
                      Center(
                        child: CachedNetworkImage(
                          height: size.height / 1.8,
                          width: size.width,
                          imageUrl: controller.currentUserPersonalImage,
                          placeholder: ((context, url) =>
                              const AppCircularProgressIndicator(
                                  width: 200.0, height: 200.0)),
                          errorWidget: ((context, url, error) =>
                              CommonFunctions.internetError),
                        ),
                      ),
                    ),
                    title: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'عرض الصورة الشخصية',
                        style: TextStyle(
                          color:
                              (Theme.of(context).brightness == Brightness.dark)
                                  ? Colors.white
                                  : AppColors.darkThemeBackgroundColor,
                          fontFamily: AppFonts.mainArabicFontFamily,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    trailing: const Icon(Icons.image_rounded),
                  ),
            ListTile(
              onTap: () {
                controller.updateUserPersonalImage(context);
              },
              title: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'تعديل الصورة الشخصية',
                  style: TextStyle(
                    color: (Theme.of(context).brightness == Brightness.dark)
                        ? Colors.white
                        : AppColors.darkThemeBackgroundColor,
                    fontFamily: AppFonts.mainArabicFontFamily,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              trailing: const Icon(Icons.edit_rounded),
            ),
            (controller.currentUserPersonalImage == null)
                ? const SizedBox()
                : ListTile(
                    onTap: () => MyAlertDialog.showAlertDialog(
                      context,
                      'إزالة الصورة الشخصية',
                      'هل انت متأكد من إزالة الصورة الشخصية؟',
                      MyAlertDialog.getAlertDialogActions(
                        {
                          'نعم': () {
                            controller.deleteUserPersonalImage();
                            Get.back(closeOverlays: true);
                          },
                          'إلغاء': () => Get.back(closeOverlays: true),
                        },
                      ),
                    ),
                    title: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'إزالة الصورة الشخصية',
                        style: TextStyle(
                          color:
                              (Theme.of(context).brightness == Brightness.dark)
                                  ? Colors.white
                                  : AppColors.darkThemeBackgroundColor,
                          fontFamily: AppFonts.mainArabicFontFamily,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    trailing: const Icon(Icons.delete_rounded),
                  ),
          ],
        ),
      ),
      backgroundColor: CommonFunctions.isLightMode(context)
          ? Colors.white
          : AppColors.darkThemeBottomNavBarColor,
    );
  }
}
