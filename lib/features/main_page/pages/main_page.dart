import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/doctor_profile/pages/doctor_profile_page.dart';
import 'package:clinic/features/main_page/controller/main_page_controller.dart';
import 'package:clinic/features/main_page/pages/main_page_option_widget.dart';
import 'package:clinic/features/notifications/controller/notification_page_controller.dart';
import 'package:clinic/features/notifications/pages/notifications_page.dart';
import 'package:clinic/features/searching/pages/search_page.dart';
import 'package:clinic/features/time_line/pages/post/doctor_post/create_doctor_post.dart';
import 'package:clinic/features/user_profile/pages/user_profile_page.dart';
import 'package:clinic/features/time_line/pages/time_line.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/features/main_page/model/bottom_navigation_bar/bottom_navigation_bar_custom_painter.dart';
import 'package:clinic/features/time_line/pages/post/user_post/create_user_post/create_user_post.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});
  static const route = '/MainPage';
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainPageController());
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          currentFocus.unfocus();
        },
        child: Stack(
          children: [
            PageView(
              controller: controller.pageController,
              onPageChanged: (selectedPage) => _getSelectedPage(selectedPage),
              physics: const NeverScrollableScrollPhysics(),
              children: [
                const SearchPage(),
                const NotificationsPage(),
                (controller.currentUserType == UserType.user)
                    ? UserProfilePage(
                        userId: controller.currentUserId,
                      )
                    : DoctorProfilePage(
                        isCurrentUser: true,
                        doctorId: controller.currentUserId,
                      ),
                const TimeLine(),
              ],
            ),
            GetX<MainPageController>(
              builder: (controller) {
                return Positioned(
                  bottom: 0,
                  child: SizedBox(
                    height: 110,
                    width: size.width,
                    child: Stack(
                      children: [
                        CustomPaint(
                          size: Size(size.width, 110),
                          painter: BottomNavBarCustomPainter(
                            color: (CommonFunctions.isLightMode(context))
                                ? Colors.white
                                : AppColors.darkThemeBottomNavBarColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Center(
                            child: FloatingActionButton(
                              onPressed: () => _createPost(),
                              backgroundColor: AppColors.primaryColor,
                              child: Icon(
                                (controller.currentUserType == UserType.user)
                                    ? Icons.question_mark_rounded
                                    : Icons.add_rounded,
                                size: 40,
                                shadows: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    spreadRadius: 0.5,
                                    blurRadius: 1,
                                    offset: Offset(0, .5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 28.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                MainPageOptionWidget(
                                  onPressed: () => _onTapPage(0, context),
                                  selected: controller.selectedPage.value == 0,
                                  optionName: 'البحث',
                                  optionIcon: Icons.search_rounded,
                                ),
                                MainPageOptionWidget(
                                  onPressed: () {
                                    _onTapPage(1, context);
                                    if (controller.newNotifications.isTrue &&
                                        Get.isRegistered<
                                            NotificationPageController>()) {
                                      NotificationPageController.find
                                          .loadNotifications(10, true);
                                    }
                                    controller.newNotifications.value = false;
                                  },
                                  selected: controller.selectedPage.value == 1,
                                  optionName: 'الإشعارات',
                                  optionIcon: Icons.notifications,
                                  notify: controller.newNotifications.value,
                                ),
                                SizedBox(width: size.width * 0.3),
                                MainPageOptionWidget(
                                  onPressed: () => _onTapPage(2, context),
                                  selected: controller.selectedPage.value == 2,
                                  optionName: 'صفحتك',
                                  optionIcon: Icons.person_rounded,
                                ),
                                MainPageOptionWidget(
                                  onPressed: () => _onTapPage(3, context),
                                  selected: controller.selectedPage.value == 3,
                                  optionName: 'المشاركات',
                                  optionIcon: Icons.question_answer_outlined,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  _createPost() {
    if (AuthenticationController.find.currentUserType == UserType.user) {
      Get.to(
        () => const CreateUserPost(),
        transition: Transition.downToUp,
      );
    } else {
      Get.to(
        () => const CreateDoctorPost(),
        transition: Transition.downToUp,
      );
    }
  }

  _getSelectedPage(int selectedPage) {
    final controller = MainPageController.find;
    controller.selectedPage.value = selectedPage;
  }

  _onTapPage(int page, BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    currentFocus.unfocus();

    final controller = MainPageController.find;
    controller.pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
}
