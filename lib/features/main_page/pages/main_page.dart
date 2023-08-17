import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/doctor_profile/pages/doctor_profile_page.dart';
import 'package:clinic/features/main_page/pages/main_page_option_widget.dart';
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

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  static const route = '/MainPage';
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _notificationsSelected = false;
  bool _searchSelected = false;
  bool _personalPageSelected = false;
  bool _timelineSelected = true;

  Widget page = const TimeLine();

  @override
  Widget build(BuildContext context) {
    final AuthenticationController authenticationController =
        AuthenticationController.find;
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          page,
          Positioned(
            bottom: 0,
            left: 0,
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
                          (authenticationController.currentUserType ==
                                  UserType.user)
                              ? Icons.question_mark_rounded
                              : Icons.add_rounded,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 45.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MainPageOptionWidget(
                            onPressed: () => setState(() {
                              _notificationsSelected = false;
                              _personalPageSelected = false;
                              _timelineSelected = false;
                              _searchSelected = true;
                            }),
                            selected: _searchSelected,
                            optionName: 'البحث',
                            optionIcon: Icons.search_rounded,
                          ),
                          MainPageOptionWidget(
                            onPressed: () => setState(() {
                              _notificationsSelected = true;
                              _personalPageSelected = false;
                              _timelineSelected = false;
                              _searchSelected = false;
                            }),
                            selected: _notificationsSelected,
                            optionName: 'الإشعارات',
                            optionIcon: Icons.notifications,
                          ),
                          SizedBox(width: size.width * 0.3),
                          MainPageOptionWidget(
                            onPressed: () => setState(() {
                              _notificationsSelected = false;
                              _searchSelected = false;
                              _timelineSelected = false;
                              _personalPageSelected = true;
                              page =
                                  (authenticationController.currentUserType ==
                                          UserType.user)
                                      ? UserProfilePage(
                                          userId: authenticationController
                                              .currentUserId,
                                        )
                                      : DoctorProfilePage(
                                          isCurrentUser: true,
                                          doctorId: authenticationController
                                              .currentUserId,
                                        );
                            }),
                            selected: _personalPageSelected,
                            optionName: 'صفحتك',
                            optionIcon: Icons.person_rounded,
                          ),
                          MainPageOptionWidget(
                            onPressed: () => setState(() {
                              _notificationsSelected = false;
                              _searchSelected = false;
                              _personalPageSelected = false;
                              _timelineSelected = true;
                              page = const TimeLine();
                            }),
                            selected: _timelineSelected,
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
          ),
        ],
      ),
    );
  }

  _createPost() {
    if (AuthenticationController.find.currentUserType == UserType.user) {
      Get.to(() => const CreateUserPost());
    } else {
      Get.to(() => const CreateDoctorPost());
    }
  }
}
