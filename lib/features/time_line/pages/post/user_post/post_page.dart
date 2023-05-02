import 'package:clinic/features/time_line/model/user_post_model.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/features/time_line/pages/post/user_post/post_widget.dart';
import 'package:flutter/material.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});
  static const route = '/postPage';

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    final UserPostModel post =
        ModalRoute.of(context)?.settings.arguments as UserPostModel;
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
      body: SingleChildScrollView(
          child: Column(
        children: [
          PostWidget(
            post: post,
            isPostPage: true,
          )
        ],
      )),
    );
  }
}
