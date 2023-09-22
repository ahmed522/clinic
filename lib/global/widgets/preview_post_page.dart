import 'package:clinic/features/settings/controller/change_degree_page_controller.dart';
import 'package:clinic/features/time_line/model/doctor_post_model.dart';
import 'package:clinic/features/time_line/pages/post/doctor_post/doctor_post_widget.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:clinic/global/widgets/default_appbar.dart';
import 'package:clinic/global/widgets/offline_page_builder.dart';
import 'package:clinic/global/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../colors/app_colors.dart';

class PreviewPostPage extends StatelessWidget {
  const PreviewPostPage({super.key, required this.post});
  final DoctorPostModel post;

  @override
  Widget build(BuildContext context) {
    String appBarTitleText =
        'منشور ${(post.writer!.gender == Gender.male) ? 'الطبيب' : 'الطبيبة'}'
        ' ${post.writer!.userName} ';
    return Scaffold(
      appBar: DefaultAppBar(
        title: appBarTitleText,
        leading: IconButton(
          onPressed: () => _onEditPostContentPressed(context, post.content!),
          icon: const Icon(
            Icons.edit_rounded,
          ),
        ),
      ),
      body: OfflinePageBuilder(
        child: ListView(
          children: [
            GetBuilder<ChangeDegreePageController>(
              builder: (controller) {
                return DoctorPostWidget(
                  post: post..content = controller.postContent,
                  isClickable: false,
                  isProfilePage: true,
                  isPreview: true,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  _onEditPostContentPressed(BuildContext context, String content) {
    final controller = ChangeDegreePageController.find;
    controller.editPostTextController.text = content;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          scrollable: true,
          title: Text(
            'تعديل المنشور',
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: AppFonts.mainArabicFontFamily,
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: (CommonFunctions.isLightMode(context))
                  ? AppColors.darkThemeBackgroundColor
                  : Colors.white,
            ),
          ),
          content: TextField(
            controller: controller.editPostTextController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: (CommonFunctions.isLightMode(context))
                      ? AppColors.primaryColor
                      : Colors.white,
                ),
              ),
            ),
            maxLength: 1000,
            maxLines: null,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
          ),
          actionsAlignment: MainAxisAlignment.start,
          actionsPadding: const EdgeInsets.only(left: 30, bottom: 30),
          actions: MyAlertDialog.getAlertDialogActions({
            'العودة': () => Get.back(),
            'تعديل': () {
              if (controller.editPostTextController.text.trim() != '') {
                controller.postContent =
                    controller.editPostTextController.text.trim();
                controller.update();
                Get.back();
              } else {
                MySnackBar.showGetSnackbar(
                  'اكتب شيئا',
                  AppColors.primaryColor,
                  isTop: false,
                  duration: const Duration(
                    milliseconds: 1000,
                  ),
                );
              }
            },
          }),
        );
      },
    );
  }
}
