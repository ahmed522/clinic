import 'package:clinic/features/time_line/controller/post_controller.dart';
import 'package:clinic/features/time_line/model/user_post_model.dart';
import 'package:clinic/features/time_line/pages/post/common/doctor_specialization_info_widget.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:clinic/global/widgets/present_number_widget.dart';
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
                DoctorSpecializationInfoWidget(
                  specialization: post.searchingSpecialization,
                ),
                const SizedBox(width: 2.0),
                Text(
                  (post.user.gender == Gender.male) ? 'يبحث عن' : 'تبحث عن',
                  style: TextStyle(
                    fontFamily: AppFonts.mainArabicFontFamily,
                    fontWeight: FontWeight.w500,
                    fontSize: (size.width > 330) ? 13 : 8,
                    color: (CommonFunctions.isLightMode(context))
                        ? Colors.black87
                        : Colors.white70,
                  ),
                ),
              ],
            ),
            GetBuilder<PostController>(builder: (controller) {
              return Row(
                children: [
                  PresentNumberWidget(number: post.reacts, fontSize: 10),
                  (post.loading)
                      ? const Padding(
                          padding: EdgeInsets.only(right: 20.0, left: 10),
                          child: AppCircularProgressIndicator(
                              width: 10, height: 10),
                        )
                      : IconButton(
                          iconSize: (size.width > 330) ? 20 : 13,
                          padding: EdgeInsets.zero,
                          onPressed: () async {
                            if (post.reacted) {
                              post.loading = true;
                              controller.update();
                              await controller.unReactPost(
                                  post.user.userId!, post.postId!);
                              post.reacted = false;
                              --post.reacts;
                              post.loading = false;
                              controller.update();
                            } else {
                              post.loading = true;
                              controller.update();
                              await controller.reactPost(
                                  post.user.userId!, post.postId!);
                              post.reacted = true;
                              ++post.reacts;
                              post.loading = false;
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
                        ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
