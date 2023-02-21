import 'package:clinic/UI/pages/user_signup_page.dart';
import 'package:clinic/global/theme/colors/light_theme_colors.dart';
import 'package:clinic/UI/pages/doctor_signup_page.dart';
import 'package:flutter/material.dart';

import '../../global/theme/fonts/app_fonst.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

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
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: LightThemeColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(
                      color: LightThemeColors.primaryColor,
                    ),
                  ),
                  shadowColor: Colors.transparent,
                ),
                child: Text(
                  'أنا طبيب',
                  style: TextStyle(
                    color: LightThemeColors.primaryColor,
                    fontFamily: AppFonts.mainArabicFontFamily,
                    fontWeight: FontWeight.bold,
                    fontSize: (size.width < 370) ? 15 : 20,
                  ),
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
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: LightThemeColors.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(
                          color: LightThemeColors.primaryColor)),
                ),
                child: Text(
                  'أنا مستخدم',
                  style: TextStyle(
                    color: LightThemeColors.primaryColor,
                    fontFamily: AppFonts.mainArabicFontFamily,
                    fontWeight: FontWeight.bold,
                    fontSize: (size.width < 370) ? 15 : 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
