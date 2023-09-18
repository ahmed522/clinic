import 'package:clinic/features/following/pages/doctor_following_card_widget.dart';
import 'package:clinic/features/user_profile/controller/user_following_page_controller.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:clinic/global/widgets/default_appbar.dart';
import 'package:clinic/global/widgets/offline_page_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class UserFollowingPage extends StatelessWidget {
  const UserFollowingPage({super.key, required this.userId});
  final String userId;
  @override
  Widget build(BuildContext context) {
    final controller =
        Get.put(UserFollowingPageController(userId), tag: userId);
    return Scaffold(
      appBar: const DefaultAppBar(title: 'الأطباء المتابَعون'),
      body: OfflinePageBuilder(
        child: RefreshIndicator(
          child: _buildFollowingDoctorsList(context),
          onRefresh: () => controller.loadFollowings(20, true),
        ),
      ),
    );
  }

  Widget _buildFollowingDoctorsList(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GetX<UserFollowingPageController>(
      tag: userId,
      builder: (controller) {
        if (controller.loading.isTrue) {
          return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: size.height,
                child: const Center(
                  child: AppCircularProgressIndicator(width: 100, height: 100),
                ),
              ));
        } else if (controller.followings.isEmpty) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height / 5),
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
          padding: const EdgeInsets.only(top: 10),
          itemCount: controller.followings.length,
          itemBuilder: (context, index) {
            if (index == controller.followings.length - 1) {
              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 20.0,
                ),
                child: Column(
                  children: [
                    DoctorFollowingCardWidget(
                      follower: controller.followings[index],
                      onUnfollowButtonPressed: () =>
                          controller.onUnfollowButtonPressed(
                        context,
                        controller.followings[index],
                      ),
                      isEditable: controller.isCurrentUserProfilePage,
                    ),
                    GetX<UserFollowingPageController>(
                      tag: userId,
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
            return DoctorFollowingCardWidget(
              follower: controller.followings[index],
              onUnfollowButtonPressed: () => controller.onUnfollowButtonPressed(
                context,
                controller.followings[index],
              ),
              isEditable: controller.isCurrentUserProfilePage,
            );
          },
        );
      },
    );
  }
}
