import 'package:clinic/features/time_line/controller/time_line_controller.dart';
import 'package:clinic/features/time_line/model/doctor_post_model.dart';
import 'package:clinic/features/time_line/model/user_post_model.dart';
import 'package:clinic/features/time_line/pages/post/doctor_post/doctor_post_widget.dart';
import 'package:clinic/features/time_line/pages/post/user_post/user_post_widget.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:clinic/global/widgets/time_line_page_clipper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class TimeLine extends StatelessWidget {
  const TimeLine({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final controller = Get.put(TimeLineController());
    return Scaffold(
      appBar: AppBar(
        title: Container(
          margin: const EdgeInsets.only(top: 25),
          child: const Text(
            'المشاركات',
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontFamily: AppFonts.mainArabicFontFamily,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        shape: TimeLinePageClipper(height: size.height / 25),
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.loadPosts(50, true),
        color: (CommonFunctions.isLightMode(context))
            ? AppColors.primaryColor
            : Colors.white,
        child: buildTimeLine(context),
      ),
    );
  }

  buildTimeLine(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GetX<TimeLineController>(
      builder: (controller) {
        if (controller.loadingPosts.isTrue) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: size.height - 100,
              child: const Center(
                child: AppCircularProgressIndicator(
                  height: 80,
                  width: 80,
                ),
              ),
            ),
          );
        } else if (controller.content.isEmpty) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: size.height - 100,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/img/noposts.svg',
                      width: 200,
                      height: 200,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'لا يوجد مشاركات حديثة',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  ]),
            ),
          );
        }
        return ListView.builder(
          itemCount: controller.content.length,
          itemBuilder: (context, index) {
            bool singlePost = controller.content.length == 1;
            if (index == 0) {
              return Padding(
                padding:
                    EdgeInsets.only(top: 40.0, bottom: singlePost ? 100 : 0),
                child:
                    (controller.content[index].writerType! == UserType.doctor)
                        ? DoctorPostWidget(
                            post: controller.content[index] as DoctorPostModel,
                          )
                        : UserPostWidget(
                            post: controller.content[index] as UserPostModel,
                          ),
              );
            } else if (index == controller.content.length - 1) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 100.0),
                child: Column(
                  children: [
                    (controller.content[index].writerType! == UserType.doctor)
                        ? DoctorPostWidget(
                            post: controller.content[index] as DoctorPostModel,
                          )
                        : UserPostWidget(
                            post: controller.content[index] as UserPostModel,
                          ),
                    GetX<TimeLineController>(
                      builder: (controller) {
                        if (controller.noMorePosts.isTrue) {
                          return const SizedBox();
                        }
                        if (controller.morePostsLoading.isTrue) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: AppCircularProgressIndicator(
                              width: 50,
                              height: 50,
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 20.0, left: 15),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: ElevatedButton(
                              onPressed: () => controller.loadPosts(25, false),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7))),
                              child: const Text(
                                'المزيد',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: AppFonts.mainArabicFontFamily,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }
            return (controller.content[index].writerType! == UserType.doctor)
                ? DoctorPostWidget(
                    post: controller.content[index] as DoctorPostModel,
                  )
                : UserPostWidget(
                    post: controller.content[index] as UserPostModel,
                  );
          },
        );
      },
    );
  }
}
