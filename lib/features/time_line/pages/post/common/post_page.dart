import 'package:clinic/features/time_line/model/doctor_post_model.dart';
import 'package:clinic/features/time_line/model/parent_post_model.dart';
import 'package:clinic/features/time_line/model/user_post_model.dart';
import 'package:clinic/features/time_line/pages/post/common/post_page_child.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:flutter/material.dart';

class PostPage extends StatelessWidget {
  const PostPage({
    super.key,
    required this.post,
    required this.writerType,
  });
  final ParentPostModel post;
  final UserType writerType;
  static const route = '/postPage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              (writerType == UserType.user)
                  ? CommonFunctions.getFullName(
                      (post as UserPostModel).user.firstName!,
                      (post as UserPostModel).user.lastName!)
                  : CommonFunctions.getFullName(
                      (post as DoctorPostModel).writer!.firstName!,
                      (post as DoctorPostModel).writer!.lastName!),
              style: const TextStyle(
                fontFamily: AppFonts.mainArabicFontFamily,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            Text(
              (writerType == UserType.user) ? ' سؤال' : ' منشور الطبيب',
              style: const TextStyle(
                fontFamily: AppFonts.mainArabicFontFamily,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: PostPageChild(
        post: post,
        writerType: writerType,
      ),
    );
  }
}
