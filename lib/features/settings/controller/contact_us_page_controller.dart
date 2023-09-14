import 'package:get/get.dart';

class ContactUsPageController extends GetxController {
  static ContactUsPageController get find => Get.find();
  bool loading = false;

  updateLoading(bool value) {
    loading = value;
    update();
  }
}
