import 'package:get/get.dart';

class FadeinAnimationController extends GetxController {
  static FadeinAnimationController get find => Get.find();
  RxBool animate = false.obs;
  Future startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    animate.value = true;
    Get.delete<FadeinAnimationController>();
  }
}
