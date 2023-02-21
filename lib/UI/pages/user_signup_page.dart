import 'package:clinic/UI/widgets/stepper_widgets/step1_content.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:flutter/material.dart';

class UserSignupPage extends StatelessWidget {
  UserSignupPage({super.key});
  static const route = '/userSignupPage';

  final Step1Content step1content = Step1Content(
    userType: UserType.user,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: step1content);
  }
}
