import 'package:clinic/features/profile/controller/user_questions_controller.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:clinic/global/widgets/page_top_widget_with_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class UserQuestionsPage extends StatelessWidget {
  const UserQuestionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          buildUserPostsList(context),
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
      init: UserQuestionsController(),
      builder: (controller) {
        if (controller.loadingPosts.isTrue) {
          return RefreshIndicator(
            displacement: size.height / 5,
            onRefresh: () => controller.loadUserPosts(),
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
        } else if (controller.noPosts.isTrue) {
          return RefreshIndicator(
            displacement: size.height / 5,
            onRefresh: () => controller.loadUserPosts(),
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
          onRefresh: () => controller.loadUserPosts(),
          child: ListView.builder(
            itemCount: controller.content.length,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: EdgeInsets.only(top: size.height / 5 - 20),
                  child: controller.content[index],
                );
              } else if (index == controller.content.length - 1) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: controller.content[index],
                );
              }
              return controller.content[index];
            },
          ),
        );
      },
    );
  }
}
