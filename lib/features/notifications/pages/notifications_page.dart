import 'package:clinic/features/notifications/controller/notification_page_controller.dart';
import 'package:clinic/features/notifications/model/notification_model.dart';
import 'package:clinic/features/notifications/pages/single_notification.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:clinic/global/widgets/appbar_widget.dart';
import 'package:clinic/global/widgets/empty_page.dart';
import 'package:clinic/global/widgets/offline_page_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final controller = Get.put(NotificationPageController());
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.height / 6),
        child: const AppBarWidget(text: '        الإشعارات'),
      ),
      body: OfflinePageBuilder(
        child: RefreshIndicator(
          onRefresh: () => controller.loadNotifications(50, true),
          color: (CommonFunctions.isLightMode(context))
              ? AppColors.primaryColor
              : Colors.white,
          child: buildNotificationsPage(context),
        ),
      ),
    );
  }

  _onNotificationPressed(BuildContext context, NotificationModel notification) {
    final controller = NotificationPageController.find;
    MyAlertDialog.showLoadingDialog(context);
    controller.getNotificationOnPressed(notification)();
  }

  buildNotificationsPage(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GetX<NotificationPageController>(builder: (controller) {
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
      if (controller.notifications.isEmpty) {
        return const EmptyPage(text: 'ليست هناك إشعارات جديدة ');
      }
      return ListView.builder(
        itemCount: controller.notifications.length,
        itemBuilder: (context, index) {
          NotificationModel notification = controller.notifications[index];
          if (!notification.seen) {
            controller.updateSeenedNotification(notification.id);
          }
          if (index == controller.notifications.length - 1) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                children: [
                  SingleNotification(
                    notification: notification,
                    onPressed: () =>
                        _onNotificationPressed(context, notification),
                  ),
                  const SizedBox(height: 10),
                  GetX<NotificationPageController>(
                    builder: (controller) {
                      if (controller.noMoreNotifications.isTrue) {
                        return const SizedBox();
                      }
                      if (controller.moreNotificaionsLoading.isTrue) {
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
                                controller.loadNotifications(25, false),
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
          return SingleNotification(
            notification: notification,
            onPressed: () => _onNotificationPressed(context, notification),
          );
        },
      );
    });
  }
}
