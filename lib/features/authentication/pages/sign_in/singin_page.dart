import 'package:clinic/features/authentication/pages/sign_in/signin_form.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(
        top: 50,
        left: size.width / 8,
        right: size.width / 8,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/img/signin.png',
              width: (size.width < AppConstants.phoneWidth) ? 80 : 100,
            ),
            const SizedBox(height: 20),
            const SigninForm(),
          ],
        ),
      ),
    );
  }
}
