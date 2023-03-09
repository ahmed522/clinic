import 'package:flutter/material.dart';

import 'package:clinic/presentation/widgets/stepper_widgets/common_stepper_widgets/main_info_widget.dart';
import 'package:clinic/global/constants/user_type.dart';

class UserSignupPage extends StatelessWidget {
  const UserSignupPage({super.key});
  static const route = '/userSignupPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainInfoWidget(
        userType: UserType.user,
      ),
    );
  }
}
