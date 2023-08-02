import 'package:clinic/features/following/pages/follower_card.dart';
import 'package:clinic/features/time_line/controller/reply_reacts_controller.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:clinic/global/widgets/containered_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReplyReactsWidget extends StatelessWidget {
  const ReplyReactsWidget({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Text(
            'التفاعلات',
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
        GetX<ReplyReactsController>(
          builder: (controller) {
            if (controller.loading.isTrue) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: AppCircularProgressIndicator(
                    width: 50,
                    height: 50,
                  ),
                ),
              );
            }
            if (controller.reacts.isEmpty) {
              return const ContaineredText(
                text: 'لا توجد تفاعلات حتى الان',
              );
            }
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.reacts.length,
              itemBuilder: (context, index) {
                if (index == controller.reacts.length - 1) {
                  return Column(
                    children: [
                      FollowerCard(follower: controller.reacts[index]),
                      GetX<ReplyReactsController>(
                        builder: (controller) {
                          if (controller.noMoreReacts.isTrue) {
                            return const SizedBox();
                          }
                          if (controller.moreReactsloading.isTrue) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 20.0),
                              child: AppCircularProgressIndicator(
                                width: 50,
                                height: 50,
                              ),
                            );
                          }
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: ElevatedButton(
                                  onPressed: () =>
                                      controller.loadReplyReacts(5, false),
                                  child: Text(
                                    'المزيد',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  )),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }
                return FollowerCard(follower: controller.reacts[index]);
              },
            );
          },
        ),
      ],
    );
  }
}
