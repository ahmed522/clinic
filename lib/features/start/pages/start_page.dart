import 'package:clinic/features/authentication/pages/sign_in/singin_page.dart';
import 'package:clinic/features/authentication/pages/sign_up/common/signup_page.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/animations/common/position_animation_model.dart';
import 'package:clinic/global/widgets/animations/fadein_animations/fadein_animation_controller.dart';
import 'package:clinic/global/widgets/animations/fadein_animations/fadein_animation_widget.dart';
import 'package:clinic/global/widgets/offline_page_builder.dart';
import 'package:flutter/material.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class StartPage extends StatelessWidget {
  static const route = '/startPage';
  const StartPage({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FadeinAnimationController());
    controller.startAnimation();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: OfflinePageBuilder(
        child: Stack(
          alignment: Alignment.center,
          children: [
            FadeinAnimationWidget(
              duration: const Duration(milliseconds: 800),
              position: PositionAnimationModel(
                topBefore: (size.width > AppConstants.phoneWidth)
                    ? size.height / 16
                    : size.height / 8,
                topAfter: (size.width > AppConstants.phoneWidth)
                    ? size.height / 12
                    : size.height / 6,
              ),
              child: SvgPicture.asset(
                'assets/img/welcome.svg',
                width: (size.width > AppConstants.phoneWidth)
                    ? 250
                    : (size.width > 300)
                        ? 200
                        : (size.width > 240)
                            ? 180
                            : 150,
                height: (size.width > AppConstants.phoneWidth)
                    ? 250
                    : (size.width > 300)
                        ? 200
                        : (size.width > 240)
                            ? 180
                            : 150,
              ),
            ),
            FadeinAnimationWidget(
              duration: const Duration(milliseconds: 1200),
              position: PositionAnimationModel(
                topAfter: (size.width > AppConstants.phoneWidth)
                    ? size.height / 12 + 250
                    : size.height / 6 + 200,
              ),
              child: Column(
                children: [
                  Text(
                    "طبيب",
                    style: TextStyle(
                      fontSize: (size.width > AppConstants.phoneWidth)
                          ? size.width / 8
                          : size.width / 4,
                      fontFamily: AppFonts.mainArabicFontFamily,
                      fontWeight: FontWeight.w500,
                      color: CommonFunctions.isLightMode(context)
                          ? AppColors.primaryColor
                          : Colors.white,
                    ),
                  ),
                  Text(
                    AppConstants.slogan,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ),
            FadeinAnimationWidget(
              duration: const Duration(milliseconds: 800),
              position: PositionAnimationModel(
                bottomBefore: size.height / 20,
                bottomAfter: size.height / 15,
              ),
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
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                    child: Text(
                      "التسجيل",
                      style: TextStyle(
                          fontSize:
                              (size.width > AppConstants.phoneWidth) ? 25 : 20,
                          fontFamily: AppFonts.mainArabicFontFamily,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
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
                    style: Theme.of(context).elevatedButtonTheme.style,
                    child: Text(
                      " تسجيل الدخول",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
