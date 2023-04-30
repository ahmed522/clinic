// ignore_for_file: must_be_immutable

import 'package:clinic/features/time_line/model/user_post_model.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonst.dart';
import 'package:clinic/features/time_line/pages/post/user_post/post_page.dart';
import 'package:clinic/global/widgets/containered_text.dart';
import 'package:clinic/features/time_line/pages/post/common/user_name_and_pic_widget.dart';
import 'package:flutter/material.dart';

class PostWidget extends StatelessWidget {
  final UserPostModel post;
  final bool isPostPage;

  PostWidget({
    super.key,
    required this.post,
    this.isPostPage = false,
  });
  bool reacted = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(5.0),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                post.isErgent
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Image.asset('assets/img/emergency.png', width: 30),
                          const Text(
                            'حالة طارئة',
                            style: TextStyle(
                              fontFamily: AppFonts.mainArabicFontFamily,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
                UserNameAndPicWidget(
                  userName: CommonFunctions.getFullName(
                      post.user.firstName!, post.user.lastName!),
                  userPic: 'assets/img/user.png',
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                (post.content != null)
                    ? post.content!
                    : AppConstants.whyMedicalId,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontFamily: AppFonts.mainArabicFontFamily,
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  color: (Theme.of(context).brightness == Brightness.light)
                      ? Colors.black87
                      : Colors.white,
                ),
              ),
            ),
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
                        : Colors.pinkAccent,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: (Theme.of(context).brightness ==
                                    Brightness.light)
                                ? AppColors.primaryColor
                                : Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          (Theme.of(context).brightness == Brightness.dark)
                              ? ColorFiltered(
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcATop,
                                  ),
                                  child: Image.network(
                                    AppConstants.specializationsIcons[
                                        post.searchingSpecialization]!,
                                    scale: 1.5,
                                  ),
                                )
                              : Image.network(
                                  AppConstants.specializationsIcons[
                                      post.searchingSpecialization]!,
                                  scale: 1.5,
                                ),
                          const SizedBox(width: 3),
                          Text(
                            post.searchingSpecialization,
                            style: TextStyle(
                              fontFamily: AppFonts.mainArabicFontFamily,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: (Theme.of(context).brightness ==
                                      Brightness.light)
                                  ? AppColors.primaryColor
                                  : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      (post.user.gender == Gender.male) ? 'يبحث عن' : 'تبحث عن',
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
                  ],
                ),
                Row(
                  children: [
                    isPostPage
                        ? const SizedBox()
                        : IconButton(
                            iconSize: 20,
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(PostPage.route, arguments: post);
                            },
                            icon: Icon(
                              Icons.comment,
                              color: (Theme.of(context).brightness ==
                                      Brightness.light)
                                  ? Colors.black87
                                  : Colors.white70,
                            ),
                          ),
                    const SizedBox(width: 2),
                    StatefulBuilder(builder: (context, setState) {
                      return IconButton(
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          if (reacted) {
                            post.reacts--;
                          } else {
                            post.reacts++;
                          }
                          setState(() => reacted = !reacted);
                        },
                        icon: Icon(
                          Icons.favorite_rounded,
                          color: reacted
                              ? Colors.red
                              : (Theme.of(context).brightness ==
                                      Brightness.light)
                                  ? Colors.black87
                                  : Colors.white70,
                        ),
                      );
                    }),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
