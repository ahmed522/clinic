import 'package:clinic/features/time_line/model/user_post_model.dart';
import 'package:clinic/features/time_line/pages/post/user_post/user_post_page_child.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:flutter/material.dart';

class PostPage extends StatelessWidget {
  const PostPage({super.key, required this.post});
  final UserPostModel post;
  static const route = '/postPage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              CommonFunctions.getFullName(
                  post.user.firstName!, post.user.lastName!),
              style: const TextStyle(
                fontFamily: AppFonts.mainArabicFontFamily,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            const Text(
              ' سؤال',
              style: TextStyle(
                fontFamily: AppFonts.mainArabicFontFamily,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: UserPostPageChild(
        post: post,
      ),
    );
  }
}
