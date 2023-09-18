import 'package:clinic/features/authentication/pages/sign_up/common/main_info_widget.dart';
import 'package:clinic/global/widgets/default_appbar.dart';
import 'package:clinic/global/widgets/offline_page_builder.dart';
import 'package:flutter/material.dart';
import 'package:clinic/global/constants/user_type.dart';

class UserSignupPage extends StatelessWidget {
  const UserSignupPage({super.key});
  static const route = '/userSignupPage';
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: DefaultAppBar(
        title: 'التسجيل',
      ),
      body: OfflinePageBuilder(
        child: MainInfoWidget(
          userType: UserType.user,
        ),
      ),
    );
  }
}
