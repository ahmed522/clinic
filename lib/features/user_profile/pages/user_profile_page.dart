import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinic/features/chat/pages/chat_page/user_chats_page.dart';
import 'package:clinic/features/doctor_profile/pages/chat_button.dart';
import 'package:clinic/features/medical_record/pages/medical_record_page.dart';
import 'package:clinic/features/user_profile/controller/user_profile_controller.dart';
import 'package:clinic/features/user_profile/pages/common/profile_option_button.dart';
import 'package:clinic/features/user_profile/pages/user_following_page.dart';
import 'package:clinic/features/user_profile/pages/user_questions_page.dart';
import 'package:clinic/features/settings/Pages/common/settings_page.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:clinic/global/widgets/offline_page_builder.dart';
import 'package:clinic/global/widgets/page_top_widget.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({
    super.key,
    required this.userId,
  });
  final String userId;

  @override
  Widget build(BuildContext context) {
    Get.put(UserProfileController(userId), tag: userId);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: OfflinePageBuilder(
        child: GetX<UserProfileController>(
          tag: userId,
          builder: (controller) {
            if (controller.loading.isTrue) {
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
                        SizedBox(height: size.height / 4),
                        Align(
                          alignment: Alignment.centerRight,
                          child: controller.isCurrentUserProfilePage ||
                                  controller.currentUserType == UserType.user
                              ? const SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: ChatButton(
                                      userId: userId, userType: UserType.user),
                                ),
                        ),
                        const SizedBox(height: 50),
                        controller.isCurrentUserProfilePage
                            ? ProfileOptionButton(
                                text: 'الدردشات',
                                imageAsset: 'assets/img/chats.png',
                                onPressed: () => Get.to(
                                  () => const UserChatsPage(),
                                  transition: Transition.rightToLeftWithFade,
                                ),
                              )
                            : const SizedBox(),
                        ProfileOptionButton(
                          text: 'الأسئلة',
                          imageAsset: 'assets/img/questions.png',
                          onPressed: () => Get.to(
                            () => UserQuestionsPage(
                              userId: userId,
                            ),
                            transition: Transition.rightToLeftWithFade,
                          ),
                        ),
                        ProfileOptionButton(
                          text: 'الأطباء المتابَعون',
                          imageAsset: 'assets/img/following-doctors.png',
                          onPressed: () => Get.to(
                            () => UserFollowingPage(
                              userId: userId,
                            ),
                            transition: Transition.rightToLeftWithFade,
                          ),
                        ),
                        controller.isCurrentUserProfilePage
                            ? ProfileOptionButton(
                                text: 'السجل المرضي',
                                imageAsset: 'assets/img/medical-record.png',
                                onPressed: () => Get.to(
                                  () => const MedicalRecordPage(),
                                  transition: Transition.rightToLeftWithFade,
                                ),
                              )
                            : const SizedBox(),
                        controller.isCurrentUserProfilePage
                            ? ProfileOptionButton(
                                text: 'الإعدادات',
                                imageAsset: 'assets/img/settings.png',
                                onPressed: () => Get.to(
                                  () => const SettingsPage(),
                                  transition: Transition.rightToLeftWithFade,
                                ),
                              )
                            : const SizedBox(),
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
                                        color: (CommonFunctions.isLightMode(
                                                context))
                                            ? Colors.grey.shade100
                                            : AppColors
                                                .darkThemeBackgroundColor,
                                        width: 2)),
                                child: GestureDetector(
                                  onTap: controller.isCurrentUserProfilePage
                                      ? () =>
                                          onPersonalImageClicked(context, size)
                                      : null,
                                  child: (controller.currentUserPersonalImage ==
                                          null)
                                      ? CircleAvatar(
                                          backgroundImage: const AssetImage(
                                              'assets/img/user.png'),
                                          radius: 100,
                                          backgroundColor:
                                              (CommonFunctions.isLightMode(
                                                      context))
                                                  ? Colors.grey.shade100
                                                  : AppColors
                                                      .darkThemeBackgroundColor,
                                        )
                                      : CircleAvatar(
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                            controller
                                                .currentUserPersonalImage!,
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
      ),
    );
  }

  onPersonalImageClicked(BuildContext context, Size size) {
    final UserProfileController controller = Get.find(tag: userId);
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
                          imageUrl: controller.currentUserPersonalImage!,
                          placeholder: ((context, url) =>
                              const AppCircularProgressIndicator(
                                  width: 100.0, height: 100.0)),
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
