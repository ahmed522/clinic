import 'package:clinic/features/doctor_profile/controller/doctor_followings_page_controller.dart';
import 'package:clinic/features/following/pages/doctor_following_card_widget.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:clinic/global/widgets/appbar_widget.dart';
import 'package:clinic/global/widgets/offline_page_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class DoctorFollowingsPage extends StatelessWidget {
  const DoctorFollowingsPage({super.key, required this.doctorId});
  final String doctorId;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final controller = Get.put(
      DoctorFollowingsPageController(doctorId),
      tag: doctorId,
    );
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.height / 6),
        child: const AppBarWidget(text: '        المتابَعون'),
      ),
      body: OfflinePageBuilder(
        child: RefreshIndicator(
          child: _buildDoctorFollowingsList(context),
          onRefresh: () => controller.loadDoctorFollowings(20, true),
        ),
      ),
    );
  }

  Widget _buildDoctorFollowingsList(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GetX<DoctorFollowingsPageController>(
      tag: doctorId,
      builder: (controller) {
        if (controller.loading.isTrue) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: 5 * size.height / 6,
              child: const Center(
                child: AppCircularProgressIndicator(
                  width: 100,
                  height: 100,
                ),
              ),
            ),
          );
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
                    'لا يوجد متابَعون',
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
                padding: const EdgeInsets.only(
                  bottom: 20.0,
                ),
                child: Column(
                  children: [
                    DoctorFollowingCardWidget(
                      follower: controller.followings[index],
                      isEditable: controller.currentUserId == doctorId,
                      onUnfollowButtonPressed:
                          (controller.currentUserId == doctorId)
                              ? () => controller.onUnfollowButtonPressed(
                                  context, controller.followings[index])
                              : () {},
                    ),
                    GetX<DoctorFollowingsPageController>(
                      tag: doctorId,
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
                          padding:
                              const EdgeInsets.only(bottom: 20.0, left: 15.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: ElevatedButton(
                              onPressed: () =>
                                  controller.loadDoctorFollowings(10, false),
                              child: Text(
                                'المزيد',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
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
              isEditable: controller.currentUserId == doctorId,
              onUnfollowButtonPressed: (controller.currentUserId == doctorId)
                  ? () => controller.onUnfollowButtonPressed(
                      context, controller.followings[index])
                  : () {},
            );
          },
        );
      },
    );
  }
}
