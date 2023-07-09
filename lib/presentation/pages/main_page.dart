import 'package:clinic/features/profile/pages/user_profile_page.dart';
import 'package:clinic/features/time_line/pages/time_line.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/presentation/widgets/bottom_navigation_bar/bottom_navigation_bar_custom_painter.dart';
import 'package:clinic/presentation/widgets/bottom_navigation_bar/bottom_navigation_bar_custom_painter_border.dart';
import 'package:clinic/features/time_line/pages/post/user_post/create_user_post.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  static const route = '/MainPage';
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _settingsSelected = false;
  bool _searchSelected = false;
  bool _personalPageSelected = false;
  bool _timelineSelected = true;
  Widget page = const TimeLine();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[50],
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
                  CustomPaint(
                    size: Size(size.width, 110),
                    painter: BottomNavBarCustomPainterBorder(
                      color: (CommonFunctions.isLightMode(context))
                          ? AppColors.primaryColor
                          : Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Center(
                      child: FloatingActionButton(
                        onPressed: () => Get.to(() => const CreateUserPost()),
                        backgroundColor: AppColors.primaryColor,
                        child: const Icon(
                          Icons.question_mark_rounded,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            padding: _searchSelected
                                ? const EdgeInsets.only(bottom: 2)
                                : const EdgeInsets.all(8.0),
                            onPressed: () {
                              setState(() {
                                _settingsSelected = false;
                                _personalPageSelected = false;
                                _timelineSelected = false;
                                _searchSelected = true;
                              });
                            },
                            icon: Icon(
                              Icons.search_rounded,
                              color: _searchSelected
                                  ? AppColors.primaryColor
                                  : (CommonFunctions.isLightMode(context))
                                      ? Colors.black54
                                      : Colors.white54,
                              size: 28,
                            ),
                          ),
                          IconButton(
                            padding: _settingsSelected
                                ? const EdgeInsets.only(bottom: 2)
                                : const EdgeInsets.all(8.0),
                            onPressed: () {
                              setState(() {
                                _searchSelected = false;
                                _personalPageSelected = false;
                                _timelineSelected = false;
                                _settingsSelected = true;
                              });
                            },
                            icon: Icon(
                              Icons.notifications,
                              color: _settingsSelected
                                  ? AppColors.primaryColor
                                  : (CommonFunctions.isLightMode(context))
                                      ? Colors.black54
                                      : Colors.white54,
                              size: 28,
                            ),
                          ),
                          SizedBox(width: size.width * 0.35),
                          IconButton(
                            padding: _personalPageSelected
                                ? const EdgeInsets.only(bottom: 2)
                                : const EdgeInsets.all(8.0),
                            onPressed: () {
                              setState(() {
                                _settingsSelected = false;
                                _searchSelected = false;
                                _timelineSelected = false;
                                _personalPageSelected = true;
                                page = const UserProfilePage();
                              });
                            },
                            icon: Icon(
                              Icons.person_rounded,
                              color: _personalPageSelected
                                  ? AppColors.primaryColor
                                  : (CommonFunctions.isLightMode(context))
                                      ? Colors.black54
                                      : Colors.white54,
                              size: 28,
                            ),
                          ),
                          IconButton(
                            padding: _timelineSelected
                                ? const EdgeInsets.only(bottom: 2)
                                : const EdgeInsets.all(8.0),
                            onPressed: () {
                              setState(() {
                                _settingsSelected = false;
                                _searchSelected = false;
                                _personalPageSelected = false;
                                _timelineSelected = true;
                                page = const TimeLine();
                              });
                            },
                            icon: Icon(
                              Icons.question_answer_outlined,
                              color: _timelineSelected
                                  ? AppColors.primaryColor
                                  : (CommonFunctions.isLightMode(context))
                                      ? Colors.black54
                                      : Colors.white54,
                              size: 28,
                            ),
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
}
