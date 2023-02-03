import 'package:clinic/core/global/Constants/user_constants.dart';
import 'package:flutter/material.dart';

import '../core/global/theme/colors/light_theme_colors.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool showPassword = false;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 50,
        left: 30,
        right: 30,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Image.asset(
                'assets/img/signin.png',
                width: 100,
              ),
              const SizedBox(height: 30),
              TextFormField(
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the e-mail';
                  } else if (!value.contains('@')) {
                    return 'Please enter a valid e-mail';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Email',
                  icon: Icon(Icons.email_rounded),
                  hintText: 'Enter your Email',
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                validator: (value) {
                  if (value == null) {
                    return 'Please enter the Password';
                  } else if (value.length < UserConstants.passwordLength) {
                    return 'Please enter a valid Password';
                  }
                  return null;
                },
                obscureText: !showPassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  icon: const Icon(Icons.password_rounded),
                  hintText: 'Enter your Password',
                  suffixIcon: IconButton(
                    icon: (showPassword)
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {}
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: LightThemeColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      )),
                  child: const Text(
                    "تسجيل الدخول",
                    style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Marhey',
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'أو قم بتسجيل الدخول من خلال',
                style: TextStyle(
                  fontFamily: 'Marhey',
                  fontSize: 15,
                ),
              ),
              const Divider(
                thickness: 2,
                indent: 50,
                endIndent: 50,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Image.asset(
                        'assets/img/google.png',
                        width: 50,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Image.asset(
                        'assets/img/facebook.png',
                        width: 50,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Image.asset(
                        'assets/img/twitter.png',
                        width: 50,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
