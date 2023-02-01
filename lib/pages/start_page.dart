import 'package:flutter/material.dart';

import '../core/global/theme/colors/light_theme_colors.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(
            top: 50,
          ),
          child: Column(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Image.asset(
                  'assets/img/startpage.png',
                ),
                const Text(
                  "مرحباً",
                  style: TextStyle(
                    fontSize: 70,
                    fontFamily: 'Marhey',
                    color: LightThemeColors.primaryColor,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: LightThemeColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      )),
                  child: const Text(
                    "التسجيل",
                    style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Marhey',
                        color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: LightThemeColors.primaryColor,
                        width: 2,
                      )),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: LightThemeColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      " تسجيل الدخول",
                      style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Marhey',
                          color: LightThemeColors.primaryColor),
                    ),
                  ),
                ),
              ]),
        ));
  }
}
