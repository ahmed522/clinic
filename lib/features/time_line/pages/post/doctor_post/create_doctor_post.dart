import 'package:clinic/features/time_line/controller/create_doctor_post_controller.dart';
import 'package:clinic/features/time_line/controller/post_controller.dart';
import 'package:clinic/features/time_line/pages/post/common/user_name_and_pic_widget.dart';
import 'package:clinic/features/time_line/pages/post/doctor_post/doctor_post_type_parent_widget.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/offline_page_builder.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateDoctorPost extends StatelessWidget {
  const CreateDoctorPost({super.key});
  static const String route = '/createUserPost';

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => PostController());
    final controller = Get.put(CreateDoctorPostController());
    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerRight,
          child: Text(
            'مشاركة منشور',
            style: TextStyle(
              fontFamily: AppFonts.mainArabicFontFamily,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
        ),
        leading: TextButton(
          onPressed: () => controller.onUploadPostButtonPressed(context),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
          ),
          child: const Text(
            'نشر',
            style: TextStyle(
              fontFamily: AppFonts.mainArabicFontFamily,
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.back();
              controller.onDelete();
            },
            icon: const Icon(
              Icons.close_rounded,
            ),
          ),
        ],
      ),
      body: OfflinePageBuilder(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
                right: 10.0,
                left: 10.0,
                bottom: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserNameAndPicWidget(
                    userName: controller.currentDoctorName,
                    userPic: controller.currentDoctorPersonalImage,
                  ),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'نوع المنشور',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  const DoctorPostTypeParentWidget(),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'اكتب شيئاً',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
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
                    maxLines: 10,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    onChanged: (content) {
                      controller.tempContent = content;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
