import 'package:clinic/features/time_line/pages/post/user_post/user_post_widget.dart';
import 'package:clinic/features/user_profile/controller/user_questions_controller.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:clinic/global/widgets/offline_page_builder.dart';
import 'package:clinic/global/widgets/page_top_widget_with_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class UserQuestionsPage extends StatelessWidget {
  const UserQuestionsPage({super.key, required this.userId});
  final String userId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          OfflinePageBuilder(child: buildUserPostsList(context)),
          const TopPageWidgetWithText(
            text: 'الأسئلة',
            fontSize: 40,
          ),
        ],
      ),
    );
  }

  buildUserPostsList(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GetX<UserQuestionsController>(
      tag: userId,
      init: UserQuestionsController(userId),
      builder: (controller) {
        if (controller.loadingPosts.isTrue) {
          return RefreshIndicator(
            displacement: size.height / 5,
            onRefresh: () => controller.loadUserPosts(10, true),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: size.height + size.height / 5,
                child: const Center(
                  child: AppCircularProgressIndicator(
                    height: 80,
                    width: 80,
                  ),
                ),
              ),
            ),
          );
        } else if (controller.content.isEmpty) {
          return RefreshIndicator(
            displacement: size.height / 5,
            onRefresh: () => controller.loadUserPosts(10, true),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: size.height + size.height / 5,
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
                          'ليس هناك أي أسئلة',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                    ]),
              ),
            ),
          );
        }
        return RefreshIndicator(
          displacement: size.height / 5,
          onRefresh: () => controller.loadUserPosts(10, true),
          child: ListView.builder(
            itemCount: controller.content.length,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: EdgeInsets.only(top: size.height / 5 - 20),
                  child: UserPostWidget(
                    post: controller.content[index],
                    isProfilePage: true,
                  ),
                );
              } else if (index == controller.content.length - 1) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      UserPostWidget(
                        post: controller.content[index],
                        isProfilePage: true,
                      ),
                      GetX<UserQuestionsController>(
                        tag: userId,
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
                                onPressed: () =>
                                    controller.loadUserPosts(10, false),
                                child: Text(
                                  'المزيد',
                                  style: Theme.of(context).textTheme.bodyText1,
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
              return UserPostWidget(
                post: controller.content[index],
                isProfilePage: true,
              );
            },
          ),
        );
      },
    );
  }
}
