import 'package:clinic/core/global/theme/colors/light_theme_colors.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 50, right: 25, left: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Image.asset(
                'assets/img/doctor.png',
                width: 70,
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: LightThemeColors.primaryColor,
                    width: 2,
                  ),
                ),
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: LightThemeColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'أنا طبيب',
                    style: TextStyle(
                      color: LightThemeColors.primaryColor,
                      fontFamily: 'Marhey',
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
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
              Container(
                margin: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: LightThemeColors.primaryColor,
                    width: 2,
                  ),
                ),
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: LightThemeColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'أنا مستخدم',
                    style: TextStyle(
                      color: LightThemeColors.primaryColor,
                      fontFamily: 'Marhey',
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
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
