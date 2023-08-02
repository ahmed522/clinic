import 'package:clinic/features/time_line/controller/post_controller.dart';
import 'package:clinic/features/time_line/model/doctor_post_model.dart';
import 'package:clinic/features/time_line/model/doctor_post_type.dart';
import 'package:clinic/features/time_line/pages/post/common/post_content_widget.dart';
import 'package:clinic/features/time_line/pages/post/common/post_page.dart';
import 'package:clinic/features/time_line/pages/post/common/post_top_widget.dart';
import 'package:clinic/features/time_line/pages/post/doctor_post/doctor_post_bottom_widget.dart';
import 'package:clinic/features/time_line/pages/post/doctor_post/doctor_post_extension_widget.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoctorPostWidget extends StatelessWidget {
  const DoctorPostWidget({
    super.key,
    required this.post,
    this.isProfilePage = false,
    this.isClickable = true,
  });
  final DoctorPostModel post;
  final bool isProfilePage;
  final bool isClickable;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final controller = Get.put<PostController>(PostController());

    return GestureDetector(
      onTap: isClickable
          ? () => Get.to(
                () => PostPage(post: post, writerType: UserType.doctor),
              )
          : null,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          decoration: BoxDecoration(
            color: (CommonFunctions.isLightMode(context))
                ? Colors.white
                : AppColors.darkThemeBackgroundColor,
            border: Border.all(
              color: post.postType == DoctorPostType.discount
                  ? AppColors.discountColor
                  : post.postType == DoctorPostType.newClinic
                      ? Colors.blueAccent
                      : post.postType == DoctorPostType.medicalInfo
                          ? AppColors.primaryColor
                          : Colors.blueGrey,
              width: 1.8,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(8),
          width: size.width,
          child: Column(
            children: [
              PostTopWidget(
                doctorId: post.doctorId,
                setSideInfo: true,
                isCurrentUserPost: controller.isCurrentUserPost(post.doctorId!),
                userName: CommonFunctions.getFullName(
                    post.writer!.firstName!, post.writer!.lastName!),
                personalImageURL: post.writer!.personalImageURL,
                postSideInfoText:
                    (post.writer!.gender == Gender.male) ? 'طبيب' : 'طبيبة',
                postSideInfoTextColor: AppColors.primaryColor,
                postSideInfoImageAsset: (post.writer!.gender == Gender.male)
                    ? 'assets/img/male-doctor.png'
                    : 'assets/img/female-doctor.png',
                timestamp: post.timeStamp!,
                paddingValue: 26,
                onSettingsButtonPressed: () => controller
                    .onPostSettingsButtonPressed(context, post.postId!, true),
                isProfilePage: isProfilePage,
              ),
              const SizedBox(
                height: 10,
              ),
              DoctorPostExtensionWidget(post: post),
              const SizedBox(
                height: 10,
              ),
              PostContentWidget(postContent: post.content!),
              const SizedBox(
                height: 10,
              ),
              DoctorPostBottomWidget(post: post, isPostPage: false),
            ],
          ),
        ),
      ),
    );
  }
}
