import 'package:clinic/features/settings/Pages/seetings_page.dart';
import 'package:clinic/features/time_line/pages/time_line.dart';
import 'package:clinic/global/colors/app_colors.dart';
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
  Widget page = TimeLine();
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
                    painter: BottomNavBarCustomPainter(),
                  ),
                  CustomPaint(
                    size: Size(size.width, 110),
                    painter: BottomNavBarCustomPainterBorder(),
                  ),
                  Center(
                    child: FloatingActionButton(
                      onPressed: () => Get.to(() => const CreateUserPost()),
                      backgroundColor: AppColors.primaryColor,
                      child: const Icon(
                        Icons.question_mark_rounded,
                        size: 30,
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
                            padding: _settingsSelected
                                ? const EdgeInsets.only(bottom: 2)
                                : const EdgeInsets.all(8.0),
                            onPressed: () {
                              setState(() {
                                _searchSelected = false;
                                _personalPageSelected = false;
                                _timelineSelected = false;
                                _settingsSelected = true;
                                page = const SettingsPage();
                              });
                            },
                            icon: Icon(
                              Icons.settings,
                              color: _settingsSelected
                                  ? AppColors.primaryColor
                                  : Colors.black54,
                              size: 28,
                            ),
                          ),
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
                                  : Colors.black54,
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
                              });
                            },
                            icon: Icon(
                              Icons.person_rounded,
                              color: _personalPageSelected
                                  ? AppColors.primaryColor
                                  : Colors.black54,
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
                                page = TimeLine();
                              });
                            },
                            icon: Icon(
                              Icons.question_answer_rounded,
                              color: _timelineSelected
                                  ? AppColors.primaryColor
                                  : Colors.black54,
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
