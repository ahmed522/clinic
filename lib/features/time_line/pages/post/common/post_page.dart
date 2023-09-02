import 'package:clinic/features/time_line/model/doctor_post_model.dart';
import 'package:clinic/features/time_line/model/parent_post_model.dart';
import 'package:clinic/features/time_line/model/user_post_model.dart';
import 'package:clinic/features/time_line/pages/post/common/post_page_child.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/widgets/offline_page_builder.dart';
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
    final size = MediaQuery.of(context).size;
    String appBarTitleText = (writerType == UserType.user)
        ? ' سؤال'
            ' ${CommonFunctions.getFullName((post as UserPostModel).user.firstName!, (post as UserPostModel).user.lastName!)} '
        : ' منشور الطبيب'
            ' ${CommonFunctions.getFullName((post as DoctorPostModel).writer!.firstName!, (post as DoctorPostModel).writer!.lastName!)} ';
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(
            appBarTitleText,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: AppFonts.mainArabicFontFamily,
              fontWeight: FontWeight.w700,
              fontSize: (size.width < 330) ? 15 : 20,
            ),
          ),
        ),
      ),
      body: OfflinePageBuilder(
        child: PostPageChild(
          post: post,
          writerType: writerType,
        ),
      ),
    );
  }
}
