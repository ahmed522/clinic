import 'package:clinic/features/time_line/controller/time_line_controller.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class TimeLine extends StatelessWidget {
  const TimeLine({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TimeLineController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('الأسئلة'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.loadPosts(),
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
        } else if (controller.noPosts.isTrue) {
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
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: controller.content[index],
              );
            } else if (index == controller.content.length - 1) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 100.0),
                child: controller.content[index],
              );
            }
            return controller.content[index];
          },
        );
      },
    );
  }
}
