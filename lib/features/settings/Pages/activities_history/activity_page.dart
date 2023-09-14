import 'package:clinic/features/settings/Pages/activities_history/delete_history_fab.dart';
import 'package:clinic/features/settings/Pages/activities_history/single_activity_list_tile.dart';
import 'package:clinic/features/settings/controller/activity_page_controller.dart';
import 'package:clinic/features/settings/model/activity.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:clinic/global/widgets/empty_page.dart';
import 'package:clinic/global/widgets/offline_page_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key, required this.activity});
  final Activity activity;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final controller =
        Get.put(ActivityPageController(activity), tag: activity.name);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_forward),
          ),
        ],
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(
            _getPageTitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: (size.width < 330) ? 15 : 20,
            ),
          ),
        ),
      ),
      body: OfflinePageBuilder(
        child: RefreshIndicator(
          onRefresh: () => controller.loadActivities(15, true),
          color: (CommonFunctions.isLightMode(context))
              ? AppColors.primaryColor
              : Colors.white,
          child: _buildActivityPage(context),
        ),
      ),
      floatingActionButton: _buildDeleteButton(context),
    );
  }

  _buildActivityPage(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GetX<ActivityPageController>(
      tag: activity.name,
      builder: (controller) {
        if (controller.loading.isTrue) {
          return SizedBox(
            height: 5 * size.height / 6,
            child: const Center(
              child: AppCircularProgressIndicator(
                width: 100,
                height: 100,
              ),
            ),
          );
        }
        RxList currentList;
        switch (activity) {
          case Activity.likedPosts:
          case Activity.writtenComments:
            currentList = controller.postsActivities;
            break;
          case Activity.likedComments:
          case Activity.writtenReplies:
            currentList = controller.commentsActivities;
            break;
          case Activity.likedReplies:
            currentList = controller.repliesActivities;
            break;
        }
        if (currentList.isEmpty) {
          return const EmptyPage(text: 'السجل فارغ');
        }
        return ListView.builder(
          itemCount: currentList.length,
          itemBuilder: (context, index) {
            var activityModel = currentList[index];

            if (index == currentList.length - 1) {
              return Padding(
                padding:
                    EdgeInsets.only(top: (index == 0) ? 15 : 0, bottom: 100),
                child: Column(
                  children: [
                    SingleActivityListTile(
                      activity: activity,
                      activityModel: activityModel,
                    ),
                    const SizedBox(height: 10),
                    GetX<ActivityPageController>(
                      tag: activity.name,
                      builder: (controller) {
                        if (controller.noMoreActivities.isTrue) {
                          return const SizedBox();
                        }
                        if (controller.moreActivitiesLoading.isTrue) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: AppCircularProgressIndicator(
                              width: 50,
                              height: 50,
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 20.0, left: 15),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: ElevatedButton(
                              onPressed: () =>
                                  controller.loadActivities(15, false),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                ),
                              ),
                              child: const Text(
                                'المزيد',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: AppFonts.mainArabicFontFamily,
                                  fontSize: 15,
                                ),
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
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: SingleActivityListTile(
                  activity: activity,
                  activityModel: activityModel,
                ),
              );
            }
            return SingleActivityListTile(
              activity: activity,
              activityModel: activityModel,
            );
          },
        );
      },
    );
  }

  Widget? _buildDeleteButton(BuildContext context) {
    return GetX<ActivityPageController>(
      tag: activity.name,
      builder: (controller) {
        RxList currentList;
        switch (activity) {
          case Activity.likedPosts:
          case Activity.writtenComments:
            currentList = controller.postsActivities;
            break;
          case Activity.likedComments:
          case Activity.writtenReplies:
            currentList = controller.commentsActivities;
            break;
          case Activity.likedReplies:
            currentList = controller.repliesActivities;
            break;
        }
        if (currentList.isEmpty) {
          return const SizedBox();
        }
        return DeleteHistoryFAB(activity: activity);
      },
    );
  }

  String get _getPageTitle {
    switch (activity) {
      case Activity.likedPosts:
        return 'المنشورات التي تفاعلت معها';
      case Activity.writtenComments:
        return 'التعليقات التي كتبتها';
      case Activity.likedComments:
        return 'التعليقات التي تفاعلت معها';
      case Activity.writtenReplies:
        return 'الردود التي كتبتها';
      case Activity.likedReplies:
        return 'الردود التي تفاعلت معها';
    }
  }
}
