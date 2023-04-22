import 'package:clinic/features/authentication/controller/sign_up/common/signup_controller.dart';
import 'package:clinic/features/authentication/pages/sign_up/common/main_info_widget.dart';
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.delete<SignupController>(tag: route);
            Navigator.of(context).pop();
          },
        ),
        title: const Align(
          alignment: Alignment.centerRight,
          child: Text(
            'التسجيل',
          ),
        ),
      ),
      body: const MainInfoWidget(
        userType: UserType.user,
      ),
    );
  }
}
