import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinic/features/chat/pages/chat_page/user_chats_page.dart';
import 'package:clinic/features/clinic/pages/presentation/clinics_page.dart';
import 'package:clinic/features/doctor_profile/controller/doctor_profile_page_controller.dart';
import 'package:clinic/features/doctor_profile/pages/chat_button.dart';
import 'package:clinic/features/doctor_profile/pages/doctor_data_widget.dart';
import 'package:clinic/features/doctor_profile/pages/doctor_followers_page.dart';
import 'package:clinic/features/doctor_profile/pages/doctor_followings_page.dart';
import 'package:clinic/features/doctor_profile/pages/doctor_posts_page.dart';
import 'package:clinic/features/doctor_profile/pages/follow_button.dart';
import 'package:clinic/features/settings/Pages/common/settings_page.dart';
import 'package:clinic/features/user_profile/pages/common/profile_option_button.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:clinic/global/widgets/image_source_page.dart';
import 'package:clinic/global/widgets/offline_page_builder.dart';
import 'package:clinic/global/widgets/page_top_widget.dart';
import 'package:clinic/global/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoctorProfilePage extends StatelessWidget {
  const DoctorProfilePage({
    super.key,
    required this.doctorId,
    required this.isCurrentUser,
  });
  final String doctorId;
  final bool isCurrentUser;
  @override
  Widget build(BuildContext context) {
    Get.put(
        DoctorProfilePageController(
            isCurrentDoctorProfile: isCurrentUser, doctorId: doctorId),
        tag: doctorId);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: OfflinePageBuilder(
        child: GetX<DoctorProfilePageController>(
            tag: doctorId,
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
                          SizedBox(height: size.height / 4 + 50),
                          DoctorDataWidget(
                            doctorId: doctorId,
                          ),
                          const SizedBox(height: 20),
                          isCurrentUser
                              ? const SizedBox()
                              : Column(
                                  children: [
                                    FollowButton(doctorId: doctorId),
                                    const SizedBox(height: 5),
                                    ChatButton(
                                      userId: doctorId,
                                      userType: UserType.doctor,
                                    ),
                                  ],
                                ),
                          isCurrentUser
                              ? ProfileOptionButton(
                                  text: 'الدردشات',
                                  imageAsset: 'assets/img/chats.png',
                                  onPressed: () {
                                    Get.to(
                                      () => const UserChatsPage(),
                                      transition:
                                          Transition.rightToLeftWithFade,
                                    );
                                  },
                                )
                              : const SizedBox(),
                          ProfileOptionButton(
                            text: 'المشاركات',
                            imageAsset: 'assets/img/posts.png',
                            onPressed: () => Get.to(
                              () => DoctorPostsPage(
                                doctorId: doctorId,
                              ),
                              transition: Transition.rightToLeftWithFade,
                            ),
                          ),
                          ProfileOptionButton(
                            text: 'المتابَعون',
                            imageAsset: 'assets/img/following.png',
                            onPressed: () => Get.to(
                              () => DoctorFollowingsPage(doctorId: doctorId),
                              transition: Transition.rightToLeftWithFade,
                            ),
                          ),
                          ProfileOptionButton(
                            text: 'المتابِعون',
                            imageAsset: 'assets/img/followers.png',
                            onPressed: () => Get.to(
                              () => DoctorFollowersPage(doctorId: doctorId),
                              transition: Transition.rightToLeftWithFade,
                            ),
                          ),
                          ProfileOptionButton(
                            text: 'العيادات',
                            imageAsset: 'assets/img/clinic.png',
                            onPressed: () => Get.to(
                              () => ClinicsPage(doctorId: doctorId),
                              transition: Transition.rightToLeftWithFade,
                            ),
                          ),
                          isCurrentUser
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
                      height: size.height / 4 + 40,
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
                                      color:
                                          (CommonFunctions.isLightMode(context))
                                              ? Colors.grey.shade100
                                              : AppColors
                                                  .darkThemeBackgroundColor,
                                      width: 2,
                                    ),
                                  ),
                                  child: GestureDetector(
                                    onTap: () => _onPersonalImageClicked(
                                      context,
                                      doctorId,
                                    ),
                                    child: CircleAvatar(
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                        isCurrentUser
                                            ? controller
                                                .currentUserPersonalImage!
                                            : controller.currentDoctor
                                                .personalImageURL!,
                                      ),
                                      radius: 100,
                                      backgroundColor:
                                          (CommonFunctions.isLightMode(context))
                                              ? Colors.grey.shade100
                                              : AppColors
                                                  .darkThemeBackgroundColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  CommonFunctions.getFullName(
                                      controller.currentDoctor.firstName!,
                                      controller.currentDoctor.lastName!),
                                  style: TextStyle(
                                    color:
                                        (CommonFunctions.isLightMode(context))
                                            ? AppColors.darkThemeBackgroundColor
                                            : Colors.white,
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
            }),
      ),
    );
  }

  _onPersonalImageClicked(BuildContext context, String doctorId) {
    final size = MediaQuery.of(context).size;
    final DoctorProfilePageController controller = Get.find(tag: doctorId);
    Get.bottomSheet(
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ListTile(
              onTap: () => Get.dialog(
                Center(
                  child: CachedNetworkImage(
                    height: size.height / 1.8,
                    width: size.width,
                    imageUrl: controller.currentDoctor.personalImageURL!,
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
                    color: (Theme.of(context).brightness == Brightness.dark)
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
            isCurrentUser
                ? ListTile(
                    onTap: () => updateUserPersonalImage(context, doctorId),
                    title: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'تعديل الصورة الشخصية',
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
                    trailing: const Icon(Icons.edit_rounded),
                  )
                : const SizedBox(),
          ],
        ),
      ),
      backgroundColor: CommonFunctions.isLightMode(context)
          ? Colors.white
          : AppColors.darkThemeBottomNavBarColor,
    );
  }
}

updateUserPersonalImage(BuildContext context, String doctorId) async {
  final DoctorProfilePageController controller = Get.find(tag: doctorId);

  Get.bottomSheet(
    Container(
      decoration: BoxDecoration(
          color: CommonFunctions.isLightMode(context)
              ? Colors.white
              : AppColors.darkThemeBottomNavBarColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          )),
      child: Wrap(
        children: [
          ImageSourcePage()
            ..onPressed = (image) async {
              if (image != null) {
                controller.currentDoctor.personalImage = File(image.path);
                confirmImageUpdateDialog(context, doctorId);
              }
            }
        ],
      ),
    ),
  );
}

confirmImageUpdateDialog(BuildContext context, String doctorId) async {
  final DoctorProfilePageController controller = Get.find(tag: doctorId);

  Get.dialog(
    Center(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Wrap(
          children: [
            Container(
              decoration: BoxDecoration(
                color: (CommonFunctions.isLightMode(context))
                    ? Colors.white
                    : AppColors.darkThemeBackgroundColor,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: DefaultTextStyle(
                      style: TextStyle(
                        fontFamily: AppFonts.mainArabicFontFamily,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color:
                            (Theme.of(context).brightness == Brightness.light)
                                ? AppColors.darkThemeBackgroundColor
                                : Colors.white,
                      ),
                      child: const Text(
                        'هل انت متأكد من تعديل الصورة الشخصية؟',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          controller.loading.value = true;
                          for (int i = 0; i < 3; i++) {
                            Get.back();
                          }
                          await controller
                              .updatePersonalImage()
                              .then((successed) {
                            if (successed) {
                              controller.currentDoctor.personalImageURL =
                                  controller.currentUserPersonalImage;
                              MySnackBar.showGetSnackbar(
                                  'تم تعديل الصورة الشخصية بنجاح',
                                  Colors.green);
                            }
                            controller.loading.value = false;
                            controller.update();
                          });
                        },
                        child: const Text(
                          'نعم',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: AppFonts.mainArabicFontFamily,
                              fontSize: 20),
                        ),
                      ),
                      const SizedBox(width: 5),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          for (int i = 0; i < 3; i++) {
                            Get.back();
                          }
                        },
                        child: const Text(
                          'إلغاء',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: AppFonts.mainArabicFontFamily,
                              fontSize: 20),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
