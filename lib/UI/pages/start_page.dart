import 'package:clinic/UI/widgets/signup_page.dart';
import 'package:clinic/UI/widgets/singin_page.dart';
import 'package:flutter/material.dart';

import '../../global/theme/colors/light_theme_colors.dart';
import '../../global/theme/fonts/app_fonst.dart';

class StartPage extends StatelessWidget {
  static const route = '/';
  const StartPage({super.key});
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Padding(
              padding: EdgeInsets.only(
                  top: size.height / 10, bottom: size.height / 20),
              child: Image.asset(
                'assets/img/startpage.png',
                width: (size.width > 370) ? size.width / 2 : size.width,
              )),
          Center(
            child: Text(
              "مرحباً",
              style: TextStyle(
                fontSize: size.width / 5,
                fontFamily: AppFonts.mainArabicFontFamily,
                color: LightThemeColors.primaryColor,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20, top: size.height / 10),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () => showModalBottomSheet<dynamic>(
                    enableDrag: false,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(35))),
                    context: context,
                    builder: (context) => Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: Wrap(children: const [
                        SignUpPage(),
                      ]),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: LightThemeColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      )),
                  child: const Text(
                    "التسجيل",
                    style: TextStyle(
                        fontSize: 30,
                        fontFamily: AppFonts.mainArabicFontFamily,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () => showModalBottomSheet<dynamic>(
                    enableDrag: false,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(35))),
                    context: context,
                    builder: (context) => Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: Wrap(
                        children: const [
                          SignInPage(),
                        ],
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: LightThemeColors.primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(
                            color: LightThemeColors.primaryColor)),
                  ),
                  child: const Text(
                    " تسجيل الدخول",
                    style: TextStyle(
                        fontSize: 30,
                        fontFamily: AppFonts.mainArabicFontFamily,
                        color: LightThemeColors.primaryColor),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
