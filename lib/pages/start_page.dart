import 'package:clinic/pages/signup_page.dart';
import 'package:clinic/pages/singin_page.dart';
import 'package:flutter/material.dart';

import '../core/global/theme/colors/light_theme_colors.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(children: [
        Padding(
          padding:
              EdgeInsets.only(top: size.height / 20, bottom: size.height / 35),
          child: Image.asset('assets/img/startpage.png',
              width: (size.width >= 450) ? size.width / 2 : size.width,
              height: (size.width <= 450) ? size.width / 1.7 : size.width / 2),
        ),
        Center(
          child: Text(
            "مرحباً",
            style: TextStyle(
              fontSize: size.width / 6,
              fontFamily: 'Marhey',
              color: LightThemeColors.primaryColor,
            ),
          ),
        ),
        Padding(
          padding:
              EdgeInsets.only(bottom: size.height / 15, top: size.height / 15),
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
                      fontSize: 30, fontFamily: 'Marhey', color: Colors.white),
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
                        SignInPage(),
                      ]),
                    ),
                  ),
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
            ],
          ),
        )
      ]),
    );
  }
}
