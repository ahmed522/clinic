import 'dart:io';

import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/data/models/user_model.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/image_source_page.dart';
import 'package:clinic/global/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfileController extends GetxController {
  UserProfileController(this.userId);
  final String userId;

  static UserProfileController get find => Get.find();
  final AuthenticationController _authenticationController =
      AuthenticationController.find;
  final UserDataController _userDataController = UserDataController.find;
  RxBool loading = true.obs;
  late String? currentUserPersonalImage;
  late String currentUserName;
  get currentUserId => _authenticationController.currentUserId;
  @override
  void onReady() async {
    loading.value = true;
    if (isCurrentUserProfilePage) {
      currentUserName = _authenticationController.currentUserName;
      currentUserPersonalImage =
          _authenticationController.currentUserPersonalImage;
    } else {
      currentUserName =
          await _userDataController.getUserNameById(userId, UserType.user);
      currentUserPersonalImage = await _userDataController
          .getUserPersonalImageURLById(userId, UserType.user);
    }
    loading.value = false;
    super.onReady();
  }

  bool get isCurrentUserProfilePage => (currentUserId == userId);
  updateUserPersonalImage(BuildContext context) async {
    UserModel user = _authenticationController.currentUser as UserModel;

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
                  user.personalImage = File(image.path);
                  confirmImageUpdateDialog(user, context);
                }
              }
          ],
        ),
      ),
    );
  }

  deleteUserPersonalImage() async {
    loading.value = true;

    await _userDataController
        .deleteUserPersonalImage(currentUserId, currentUserPersonalImage!)
        .then((value) {
      currentUserPersonalImage =
          _authenticationController.currentUserPersonalImage;
      MySnackBar.showGetSnackbar('تم حذف الصورة الشخصية بنجاح', Colors.green);
      loading.value = false;
      update();
    });
  }

  confirmImageUpdateDialog(UserModel user, BuildContext context) async =>
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
                            color: (Theme.of(context).brightness ==
                                    Brightness.light)
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
                              loading.value = true;
                              Get.back(closeOverlays: true);
                              await _userDataController
                                  .updateUserPersonalImage(currentUserId, user)
                                  .then((successed) {
                                if (successed) {
                                  currentUserPersonalImage =
                                      _authenticationController
                                          .currentUserPersonalImage;
                                  MySnackBar.showGetSnackbar(
                                      'تم تعديل الصورة الشخصية بنجاح',
                                      Colors.green);
                                }
                                loading.value = false;
                                update();
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
                              Get.back(closeOverlays: true);
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
