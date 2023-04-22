import 'package:clinic/features/authentication/pages/sign_up/doctor/doctor_signup_page.dart';
import 'package:clinic/features/authentication/pages/sign_up/user/user_signup_page.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 40,
        bottom: 50,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Image.asset(
                'assets/img/doctor.png',
                width: 70,
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, DoctorSignupPage.route),
                style: Theme.of(context).elevatedButtonTheme.style,
                child: Text(
                  'أنا طبيب',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ],
          ),
          Column(
            children: [
              Image.asset(
                'assets/img/user.png',
                width: 70,
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, UserSignupPage.route),
                style: Theme.of(context).elevatedButtonTheme.style,
                child: Text(
                  'أنا مستخدم',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
