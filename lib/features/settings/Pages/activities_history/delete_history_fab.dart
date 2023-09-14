import 'package:clinic/features/settings/controller/activity_page_controller.dart';
import 'package:clinic/features/settings/model/activity.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:clinic/global/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteHistoryFAB extends StatelessWidget {
  const DeleteHistoryFAB({
    Key? key,
    required this.activity,
  }) : super(key: key);
  final Activity activity;
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab,
          _buildDeleteFab(context),
          _buildDeleteAllFab(context),
          _buildTapToOpenFab,
        ],
      ),
    );
  }

  Widget get _buildTapToCloseFab {
    final controller = ActivityPageController.find(activity.name);
    return SizedBox(
      width: 56,
      height: 56,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 3,
          child: InkWell(
            onTap: () {
              controller.deletedActivities.clear();
              controller.deleteFabOpen.toggle();
            },
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.close,
                color: Colors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteAllFab(BuildContext context) {
    return GetX<ActivityPageController>(
      tag: activity.name,
      builder: (controller) {
        return AnimatedPositioned(
          bottom: controller.deleteFabOpen.isTrue ? 50 : 0,
          duration: const Duration(milliseconds: 200),
          child: SizedBox(
            width: 56,
            height: 56,
            child: Center(
              child: Material(
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                elevation: 3,
                color: Colors.red,
                child: InkWell(
                  onTap: () => _deleteAllActivities(context),
                  onLongPress: () =>
                      MySnackBar.showSnackBar(context, 'حذف السجل بالكامل'),
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(
                      Icons.delete_forever,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDeleteFab(BuildContext context) {
    return GetX<ActivityPageController>(
      tag: activity.name,
      builder: (controller) {
        return AnimatedPositioned(
          bottom: controller.deleteFabOpen.isTrue ? 100 : 0,
          duration: const Duration(milliseconds: 200),
          child: SizedBox(
            width: 56,
            height: 56,
            child: Center(
              child: Material(
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                elevation: controller.deletedActivities.isEmpty ? 0.5 : 3,
                color: Colors.red
                    .withOpacity(controller.deletedActivities.isEmpty ? 0 : 1),
                child: InkWell(
                  onTap: controller.deletedActivities.isEmpty
                      ? null
                      : () => _deleteSelectedActivities(context),
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget get _buildTapToOpenFab {
    return GetX<ActivityPageController>(
      tag: activity.name,
      builder: (controller) {
        return IgnorePointer(
          ignoring: controller.deleteFabOpen.isTrue,
          child: AnimatedContainer(
            transformAlignment: Alignment.center,
            transform: Matrix4.diagonal3Values(
              controller.deleteFabOpen.isTrue ? 0.7 : 1.0,
              controller.deleteFabOpen.isTrue ? 0.7 : 1.0,
              1.0,
            ),
            duration: const Duration(milliseconds: 200),
            curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
            child: AnimatedOpacity(
              opacity: controller.deleteFabOpen.isTrue ? 0.0 : 1.0,
              curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
              duration: const Duration(milliseconds: 200),
              child: FloatingActionButton(
                onPressed: () {
                  controller.deleteFabOpen.toggle();
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                elevation: 5,
                tooltip: 'حذف',
                child: const Icon(Icons.delete_rounded),
              ),
            ),
          ),
        );
      },
    );
  }

  _deleteAllActivities(BuildContext context) {
    final controller = ActivityPageController.find(activity.name);
    MyAlertDialog.showAlertDialog(
      context,
      'حذف السجل بالكامل',
      'هل أنت متأكد من حذف السجل بالكامل؟',
      MyAlertDialog.getAlertDialogActions(
        {
          'العودة': () => Get.back(),
          'حذف': () {
            Get.back();
            controller.deleteAllActivities();
          },
        },
      ),
    );
  }

  _deleteSelectedActivities(BuildContext context) {
    final controller = ActivityPageController.find(activity.name);
    MyAlertDialog.showAlertDialog(
      context,
      'حذف الأنشطة المحددة',
      'هل أنت متأكد من حذف الأنشطة المحددة؟',
      MyAlertDialog.getAlertDialogActions(
        {
          'العودة': () => Get.back(),
          'حذف': () {
            Get.back();
            controller.deleteActivities();
          },
        },
      ),
    );
  }
}
