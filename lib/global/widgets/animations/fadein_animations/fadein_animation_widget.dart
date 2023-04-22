import 'package:clinic/global/widgets/animations/fadein_animations/fadein_animation_controller.dart';
import 'package:clinic/global/widgets/animations/common/position_animation_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FadeinAnimationWidget extends StatelessWidget {
  final Duration duration;
  final FadeinAnimationController controller =
      Get.put(FadeinAnimationController());
  final PositionAnimationModel position;
  final Widget child;
  FadeinAnimationWidget(
      {super.key,
      required this.duration,
      required this.position,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedPositioned(
        duration: duration,
        bottom: controller.animate.value
            ? position.bottomAfter
            : position.bottomBefore,
        left:
            controller.animate.value ? position.leftAfter : position.leftBefore,
        top: controller.animate.value ? position.topAfter : position.topBefore,
        right: controller.animate.value
            ? position.rightAfter
            : position.rightBefore,
        child: AnimatedOpacity(
          duration: duration,
          opacity: controller.animate.value ? 1 : 0,
          child: child,
        ),
      ),
    );
  }
}
