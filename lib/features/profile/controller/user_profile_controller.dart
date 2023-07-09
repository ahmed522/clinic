import 'dart:io';

import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/features/time_line/controller/time_line_controller.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/data/models/user_model.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/image_source_page.dart';
import 'package:clinic/global/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfileController extends GetxController {
  static UserProfileController get find => Get.find();
  final AuthenticationController _authenticationController =
      AuthenticationController.find;
  final UserDataController _userDataController = UserDataController.find;
  RxBool updateImageLoading = false.obs;
  final TimeLineController _timeLineController = TimeLineController.find;
  get currentUserPersonalImage =>
      _authenticationController.currentUserPersonalImage;
  get currentUserName => _authenticationController.currentUserName;
  get currentUserId => _authenticationController.currentUserId;
  get currentUserGender => _authenticationController.currentUserGender;
  get currentUserBirthDate => _authenticationController.currentUserBirthDate;

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
    updateImageLoading.value = true;

    await _userDataController
        .deleteUserPersonalImage(currentUserId, currentUserPersonalImage)
        .then((value) {
      _timeLineController.loadPosts();
      MySnackBar.showGetSnackbar('تم حذف الصورة الشخصية بنجاح', Colors.green);
      updateImageLoading.value = false;
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
                              updateImageLoading.value = true;
                              Get.back(closeOverlays: true);
                              await _userDataController
                                  .updateUserPersonalImage(currentUserId, user)
                                  .then((successed) {
                                if (successed) {
                                  _timeLineController.loadPosts();
                                  MySnackBar.showGetSnackbar(
                                      'تم تعديل الصورة الشخصية بنجاح',
                                      Colors.green);
                                }
                                updateImageLoading.value = false;
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
