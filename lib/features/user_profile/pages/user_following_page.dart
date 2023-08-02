import 'package:clinic/features/following/pages/doctor_following_card_widget.dart';
import 'package:clinic/features/user_profile/controller/user_following_page_controller.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:clinic/global/widgets/page_top_widget_with_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class UserFollowingPage extends StatelessWidget {
  const UserFollowingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final controller = Get.put(UserFollowingPageController());
    return Scaffold(
      body: Stack(
        children: [
          RefreshIndicator(
            displacement: size.height / 5,
            child: _buildFollowingDoctorsList(context),
            onRefresh: () => controller.loadFollowings(20, true),
          ),
          const TopPageWidgetWithText(
            text: 'الأطباء المتابَعون',
            fontSize: 25,
          ),
        ],
      ),
    );
  }

  Widget _buildFollowingDoctorsList(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GetX<UserFollowingPageController>(
      builder: (controller) {
        if (controller.loading.isTrue) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height / 2),
                const Center(
                  child: AppCircularProgressIndicator(width: 100, height: 100),
                )
              ],
            ),
          );
        } else if (controller.followings.isEmpty) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height / 3),
                SvgPicture.asset(
                  'assets/img/empty.svg',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(
                  height: 30,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'لا يوجد أطباء متابَعون',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: controller.followings.length,
          itemBuilder: (context, index) {
            if (index == controller.followings.length - 1) {
              return Padding(
                padding: EdgeInsets.only(
                  top: index == 0 ? size.height / 4 - 50 : 0,
                  bottom: 20.0,
                ),
                child: Column(
                  children: [
                    DoctorFollowingCardWidget(
                      follower: controller.followings[index],
                      onUnfollowButtonPressed: () =>
                          controller.onUnfollowButtonPressed(
                              context, controller.followings[index]),
                      isEditable: true,
                    ),
                    GetX<UserFollowingPageController>(
                      builder: (controller) {
                        if (controller.noMoreFollowings.isTrue) {
                          return const SizedBox();
                        }
                        if (controller.moreFollowingsLoading.isTrue) {
                          return const Padding(
                            padding: EdgeInsets.only(bottom: 20.0),
                            child: AppCircularProgressIndicator(
                              width: 50,
                              height: 50,
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: ElevatedButton(
                            onPressed: () =>
                                controller.loadFollowings(10, false),
                            child: Text(
                              'المزيد',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }
            return Padding(
              padding:
                  EdgeInsets.only(top: index == 0 ? size.height / 4 - 50 : 0),
              child: DoctorFollowingCardWidget(
                follower: controller.followings[index],
                onUnfollowButtonPressed: () =>
                    controller.onUnfollowButtonPressed(
                        context, controller.followings[index]),
                isEditable: true,
              ),
            );
          },
        );
      },
    );
  }
}
