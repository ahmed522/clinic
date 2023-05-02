import 'package:clinic/features/authentication/pages/sign_in/signin_form.dart';
import 'package:clinic/features/authentication/pages/sign_in/signin_image_widget.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});
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
          children: const [
            SigninImageWidget(),
            SizedBox(height: 20),
            SigninForm(),
          ],
        ),
      ),
    );
  }
}
