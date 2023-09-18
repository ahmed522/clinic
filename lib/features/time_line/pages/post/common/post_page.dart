import 'package:clinic/features/time_line/model/doctor_post_model.dart';
import 'package:clinic/features/time_line/model/parent_post_model.dart';
import 'package:clinic/features/time_line/model/user_post_model.dart';
import 'package:clinic/features/time_line/pages/post/common/post_page_child.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/default_appbar.dart';
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
    Gender writerGender = (writerType == UserType.user)
        ? (post as UserPostModel).user.gender
        : (post as DoctorPostModel).writer!.gender;
    String appBarTitleText = (writerType == UserType.user)
        ? 'سؤال'
            ' ${CommonFunctions.getFullName((post as UserPostModel).user.firstName!, (post as UserPostModel).user.lastName!)} '
        : 'منشور ${(writerGender == Gender.male) ? 'الطبيب' : 'الطبيبة'}'
            ' ${CommonFunctions.getFullName((post as DoctorPostModel).writer!.firstName!, (post as DoctorPostModel).writer!.lastName!)} ';
    return Scaffold(
      appBar: DefaultAppBar(
        title: appBarTitleText,
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
