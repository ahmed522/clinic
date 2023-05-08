import 'package:clinic/features/time_line/controller/time_line_controller.dart';
import 'package:clinic/global/colors/app_colors.dart';
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
        color: (Theme.of(context).brightness == Brightness.light)
            ? AppColors.primaryColor
            : Colors.white,
        child: buildTimeLine(context),
      ),
    );
  }

  buildTimeLine(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GetX<TimeLineController>(builder: (controller) {
      if ((controller.loadingPosts.isTrue && controller.noPosts.isFalse) ||
          controller.content.isEmpty) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: size.height - 100,
            child: Center(
              child: SizedBox(
                height: 80,
                width: 80,
                child: CircularProgressIndicator(
                  color: (Theme.of(context).brightness == Brightness.light)
                      ? AppColors.primaryColor
                      : Colors.white,
                ),
              ),
            ),
          ),
        );
      } else if (controller.noPosts.isTrue) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: size.height - 100,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
      } else {
        return ListView(children: [
          const SizedBox(height: 10),
          Column(
            children: controller.content,
          ),
          const SizedBox(height: 100),
        ]);
      }
    });
  }
}
