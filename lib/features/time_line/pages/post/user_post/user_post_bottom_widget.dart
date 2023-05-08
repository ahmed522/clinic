import 'package:clinic/features/time_line/controller/post_controller.dart';
import 'package:clinic/features/time_line/model/user_post_model.dart';
import 'package:clinic/features/time_line/pages/post/user_post/post_page.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserPostBottomWidget extends StatelessWidget {
  const UserPostBottomWidget({
    Key? key,
    required this.post,
    required this.isPostPage,
  }) : super(key: key);

  final UserPostModel post;
  final bool isPostPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    color: (Theme.of(context).brightness == Brightness.light)
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
                      color: (Theme.of(context).brightness == Brightness.light)
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
                color: (Theme.of(context).brightness == Brightness.light)
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
                      Get.to(() => PostPage(
                            post: post,
                          ));
                    },
                    icon: Icon(
                      Icons.comment,
                      color: (Theme.of(context).brightness == Brightness.light)
                          ? Colors.black87
                          : Colors.white70,
                    ),
                  ),
            const SizedBox(width: 2),
            GetBuilder<PostController>(builder: (controller) {
              return IconButton(
                iconSize: 20,
                padding: EdgeInsets.zero,
                onPressed: () {
                  if (post.reacted) {
                    controller.unReactPost(post.user.userId!, post.postId!);
                    post.reacted = false;
                    controller.update();
                  } else {
                    controller.reactPost(post.user.userId!, post.postId!);
                    post.reacted = true;
                    controller.update();
                  }
                },
                icon: Icon(
                  Icons.favorite_rounded,
                  color: post.reacted
                      ? Colors.red
                      : (Theme.of(context).brightness == Brightness.light)
                          ? Colors.black87
                          : Colors.white70,
                ),
              );
            }),
          ],
        )
      ],
    );
  }
}
