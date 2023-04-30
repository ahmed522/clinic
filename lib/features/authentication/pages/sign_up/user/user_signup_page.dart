import 'package:clinic/features/authentication/pages/sign_up/common/main_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:clinic/global/constants/user_type.dart';

class UserSignupPage extends StatelessWidget {
  const UserSignupPage({super.key});
  static const route = '/userSignupPage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
