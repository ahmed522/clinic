import 'package:clinic/features/authentication/pages/sign_up/common/main_info_widget.dart';
import 'package:clinic/global/widgets/offline_page_builder.dart';
import 'package:flutter/material.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:get/get.dart';

class UserSignupPage extends StatelessWidget {
  const UserSignupPage({super.key});
  static const route = '/userSignupPage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_forward),
          ),
        ],
        title: const Align(
          alignment: Alignment.centerRight,
          child: Text(
            'التسجيل',
          ),
        ),
      ),
      body: const OfflinePageBuilder(
        child: MainInfoWidget(
          userType: UserType.user,
        ),
      ),
    );
  }
}
