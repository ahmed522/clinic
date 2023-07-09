import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinic/features/time_line/controller/post_controller.dart';
import 'package:clinic/features/time_line/model/user_post_model.dart';
import 'package:clinic/features/time_line/pages/post/user_post/post_page.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
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
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: size.width - 26,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: (CommonFunctions.isLightMode(context))
                            ? AppColors.primaryColor
                            : Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      (size.width > 330)
                          ? (Theme.of(context).brightness == Brightness.dark)
                              ? ColorFiltered(
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcATop,
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: AppConstants.specializationsIcons[
                                        post.searchingSpecialization]!,
                                    width: (size.width > 330) ? 20 : 15,
                                    height: (size.width > 330) ? 20 : 15,
                                    placeholder: (context, url) =>
                                        const SizedBox(),
                                  ),
                                )
                              : CachedNetworkImage(
                                  imageUrl: AppConstants.specializationsIcons[
                                      post.searchingSpecialization]!,
                                  width: (size.width > 330) ? 20 : 15,
                                  height: (size.width > 330) ? 20 : 15,
                                  placeholder: (context, url) =>
                                      const SizedBox(),
                                )
                          : const SizedBox(),
                      SizedBox(width: (size.width > 330) ? 3 : 0),
                      Text(
                        post.searchingSpecialization,
                        style: TextStyle(
                          fontFamily: AppFonts.mainArabicFontFamily,
                          fontWeight: FontWeight.w600,
                          fontSize: (size.width > 330) ? 12 : 10,
                          color: (CommonFunctions.isLightMode(context))
                              ? AppColors.primaryColor
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 2.0),
                Text(
                  (post.user.gender == Gender.male) ? 'يبحث عن' : 'تبحث عن',
                  style: TextStyle(
                    fontFamily: AppFonts.mainArabicFontFamily,
                    fontWeight: FontWeight.w500,
                    fontSize: (size.width > 330) ? 13 : 10,
                    color: (CommonFunctions.isLightMode(context))
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
                        iconSize: (size.width > 330) ? 20 : 15,
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Get.to(() => PostPage(
                                post: post,
                              ));
                        },
                        icon: Icon(
                          Icons.comment,
                          color: (CommonFunctions.isLightMode(context))
                              ? Colors.black87
                              : Colors.white70,
                        ),
                      ),
                const SizedBox(width: 2),
                GetBuilder<PostController>(builder: (controller) {
                  return IconButton(
                    iconSize: (size.width > 330) ? 20 : 15,
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
                          : (CommonFunctions.isLightMode(context))
                              ? Colors.black87
                              : Colors.white70,
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
