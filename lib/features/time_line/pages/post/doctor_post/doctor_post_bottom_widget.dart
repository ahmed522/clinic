import 'package:clinic/features/time_line/controller/post_controller.dart';
import 'package:clinic/features/time_line/model/doctor_post_model.dart';
import 'package:clinic/features/time_line/pages/post/common/doctor_specialization_info_widget.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:clinic/global/widgets/present_number_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoctorPostBottomWidget extends StatelessWidget {
  const DoctorPostBottomWidget({
    Key? key,
    required this.post,
    required this.isPostPage,
    this.isPreview = false,
  }) : super(key: key);

  final DoctorPostModel post;
  final bool isPostPage;
  final bool isPreview;
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
            DoctorSpecializationInfoWidget(
              specialization: post.writer!.specialization,
            ),
            GetBuilder<PostController>(
              builder: (controller) {
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
                                if (!isPreview) {
                                  post.loading = true;
                                  controller.update();
                                  await controller.unReactPost(post.postId!);
                                }
                                post.reacted = false;
                                --post.reacts;
                                post.loading = false;
                                controller.update();
                              } else {
                                if (!isPreview) {
                                  post.loading = true;
                                  controller.update();
                                  await controller.reactPost(post);
                                }
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
              },
            ),
          ],
        ),
      ),
    );
  }
}
