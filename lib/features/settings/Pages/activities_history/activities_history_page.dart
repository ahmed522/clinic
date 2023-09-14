import 'package:clinic/features/settings/Pages/activities_history/activity_page.dart';
import 'package:clinic/features/settings/Pages/common/single_setting.dart';
import 'package:clinic/features/settings/model/activity.dart';
import 'package:clinic/global/widgets/offline_page_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActivitiesHistoryPage extends StatelessWidget {
  const ActivitiesHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
            'سجل النشاطات',
            style: TextStyle(
              color: Colors.white,
              fontSize: (size.width < 330) ? 17 : 20,
            ),
          ),
        ),
      ),
      body: OfflinePageBuilder(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: Column(
              children: [
                SingleSetting(
                  text: 'المنشورات التي تفاعلت معها',
                  icon: Icons.favorite_rounded,
                  onPressed: () => Get.to(
                    () => const ActivityPage(activity: Activity.likedPosts),
                    transition: Transition.rightToLeftWithFade,
                  ),
                ),
                SingleSetting(
                  text: 'التعليقات التي كتبتها',
                  icon: Icons.comment,
                  onPressed: () => Get.to(
                    () =>
                        const ActivityPage(activity: Activity.writtenComments),
                    transition: Transition.rightToLeftWithFade,
                  ),
                ),
                SingleSetting(
                  text: 'التعليقات التي تفاعلت معها',
                  icon: Icons.favorite_border_rounded,
                  onPressed: () => Get.to(
                    () => const ActivityPage(activity: Activity.likedComments),
                    transition: Transition.rightToLeftWithFade,
                  ),
                ),
                SingleSetting(
                  text: 'الردود التي كتبتها',
                  icon: Icons.insert_comment_outlined,
                  onPressed: () => Get.to(
                    () => const ActivityPage(activity: Activity.writtenReplies),
                    transition: Transition.rightToLeftWithFade,
                  ),
                ),
                SingleSetting(
                  text: 'الردود التي تفاعلت معها',
                  icon: Icons.favorite_border_rounded,
                  onPressed: () => Get.to(
                    () => const ActivityPage(activity: Activity.likedReplies),
                    transition: Transition.rightToLeftWithFade,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
