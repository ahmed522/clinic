import 'package:clinic/features/time_line/controller/post_controller.dart';
import 'package:clinic/features/time_line/model/user_post_model.dart';
import 'package:clinic/features/time_line/pages/post/common/post_content_widget.dart';
import 'package:clinic/features/time_line/pages/post/common/post_top_widget.dart';
import 'package:clinic/features/time_line/pages/post/user_post/user_post_bottom_widget.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/widgets/containered_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserPostWidget extends StatelessWidget {
  final UserPostModel post;
  final bool isPostPage;

  const UserPostWidget({
    super.key,
    required this.post,
    this.isPostPage = false,
  });

  @override
  Widget build(BuildContext context) {
    Get.put<PostController>(PostController());

    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: isPostPage
          ? const EdgeInsets.only(right: 5.0, left: 5.0, top: 5.0, bottom: 10.0)
          : const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          color: (Theme.of(context).brightness == Brightness.light)
              ? Colors.white
              : AppColors.darkThemeBackgroundColor,
          border: Border.all(
            color: post.isErgent
                ? Colors.red
                : (Theme.of(context).brightness == Brightness.light)
                    ? AppColors.primaryColor
                    : Colors.white,
            width: post.isErgent ? 1.0 : 0.2,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(8),
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostTopWidget(
              setSideInfo: post.isErgent,
              userName: CommonFunctions.getFullName(
                  post.user.firstName!, post.user.lastName!),
              personalImageURL: post.user.personalImageURL!,
              postSideInfoText: 'حالة طارئة',
              postSideInfoTextColor: Colors.red,
              postSideInfoImageAsset: 'assets/img/emergency.png',
              timestamp: post.timeStamp!,
            ),
            const SizedBox(
              height: 10,
            ),
            PostContentWidget(postContent: post.content!),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Text(
                  'بيانات الحالة',
                  style: TextStyle(
                    fontFamily: AppFonts.mainArabicFontFamily,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: (Theme.of(context).brightness == Brightness.light)
                        ? AppColors.primaryColor
                        : Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (post.patientGender == Gender.male)
                        ? AppColors.primaryColor
                        : Colors.pink,
                  ),
                  child: Icon(
                    (post.patientGender == Gender.male)
                        ? Icons.male_rounded
                        : Icons.female_rounded,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    Text(
                      'سنة',
                      style: TextStyle(
                        fontFamily: AppFonts.mainArabicFontFamily,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color:
                            (Theme.of(context).brightness == Brightness.light)
                                ? Colors.black87
                                : Colors.white70,
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      post.patientAge['years'].toString(),
                      style: TextStyle(
                        fontFamily: AppFonts.mainArabicFontFamily,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color:
                            (Theme.of(context).brightness == Brightness.light)
                                ? AppColors.primaryColor
                                : Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'شهر',
                      style: TextStyle(
                        fontFamily: AppFonts.mainArabicFontFamily,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color:
                            (Theme.of(context).brightness == Brightness.light)
                                ? Colors.black87
                                : Colors.white70,
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      post.patientAge['months'].toString(),
                      style: TextStyle(
                        fontFamily: AppFonts.mainArabicFontFamily,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color:
                            (Theme.of(context).brightness == Brightness.light)
                                ? AppColors.primaryColor
                                : Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'يوم',
                      style: TextStyle(
                        fontFamily: AppFonts.mainArabicFontFamily,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color:
                            (Theme.of(context).brightness == Brightness.light)
                                ? Colors.black87
                                : Colors.white70,
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      post.patientAge['days'].toString(),
                      style: TextStyle(
                        fontFamily: AppFonts.mainArabicFontFamily,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color:
                            (Theme.of(context).brightness == Brightness.light)
                                ? AppColors.primaryColor
                                : Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            (post.patientDiseases.isEmpty)
                ? Center(
                    child: Container(
                      padding: const EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.circular(20)),
                      child: const Text(
                        'الحالة لا تعاني من أي أمراض مزمنة',
                        style: TextStyle(
                          fontFamily: AppFonts.mainArabicFontFamily,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(right: 15.0, left: 10.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text('الأمراض المزمنة لدى الحالة',
                                style: Theme.of(context).textTheme.bodyText1),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List<Row>.generate(
                                post.patientDiseases.length,
                                (index) => Row(
                                  children: [
                                    ContaineredText(
                                        text: post.patientDiseases[index]),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ]),
                  ),
            const SizedBox(
              height: 10,
            ),
            UserPostBottomWidget(post: post, isPostPage: isPostPage),
          ],
        ),
      ),
    );
  }
}