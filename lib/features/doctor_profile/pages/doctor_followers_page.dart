import 'package:clinic/features/doctor_profile/controller/doctor_followers_page_controller.dart';
import 'package:clinic/features/following/pages/follower_card.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:clinic/global/widgets/page_top_widget_with_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class DoctorFollowersPage extends StatelessWidget {
  const DoctorFollowersPage({super.key, required this.doctorId});
  final String doctorId;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final controller = Get.put(
      DoctorFollowersPageController(doctorId),
      tag: doctorId,
    );
    return Scaffold(
      body: Stack(
        children: [
          RefreshIndicator(
            displacement: size.height / 5,
            child: _buildDoctorFollowersList(context),
            onRefresh: () => controller.loadDoctorFollowers(20, true),
          ),
          const TopPageWidgetWithText(
            text: 'المتابِعون',
            fontSize: 40,
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorFollowersList(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GetX<DoctorFollowersPageController>(
      tag: doctorId,
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
        } else if (controller.followers.isEmpty) {
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
                    'لا يوجد متابِعون',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
            itemCount: controller.followers.length,
            itemBuilder: (context, index) {
              if (index == controller.followers.length - 1) {
                return Padding(
                  padding: EdgeInsets.only(
                    top: index == 0 ? size.height / 4 - 50 : 0,
                    bottom: 20.0,
                  ),
                  child: Column(
                    children: [
                      FollowerCard(
                        follower: controller.followers[index],
                      ),
                      GetX<DoctorFollowersPageController>(
                        tag: doctorId,
                        builder: (controller) {
                          if (controller.noMoreFollowers.isTrue) {
                            return const SizedBox();
                          }
                          if (controller.moreFollowersLoading.isTrue) {
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
                                const EdgeInsets.only(bottom: 20.0, left: 15),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: ElevatedButton(
                                onPressed: () =>
                                    controller.loadDoctorFollowers(10, false),
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
              return Padding(
                padding:
                    EdgeInsets.only(top: index == 0 ? size.height / 4 - 50 : 0),
                child: FollowerCard(
                  follower: controller.followers[index],
                ),
              );
            });
      },
    );
  }
}
