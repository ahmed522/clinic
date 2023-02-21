import 'package:clinic/global/constants/app_constants.dart';
import 'package:flutter/material.dart';

import '../../global/theme/colors/light_theme_colors.dart';
import '../../global/theme/fonts/app_fonst.dart';

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
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(
        top: 50,
        left: size.width / 8,
        right: size.width / 8,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Image.asset(
                'assets/img/signin.png',
                width: (size.width < 500) ? 80 : 100,
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'البريد الإلكتروني',
                  style: TextStyle(
                    fontFamily: AppFonts.mainArabicFontFamily,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: LightThemeColors.primaryColor,
                  ),
                ),
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'من فضلك ادخل البريد الإلكتروني';
                  } else {
                    final bool emailValid =
                        RegExp(AppConstants.emailValidationRegExp)
                            .hasMatch(value);
                    if (!emailValid) {
                      return 'من فضلك ادخل بريدإلكتروني صحيح';
                    }
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
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'كلمة المرور',
                  style: TextStyle(
                    fontFamily: AppFonts.mainArabicFontFamily,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: LightThemeColors.primaryColor,
                  ),
                ),
              ),
              TextFormField(
                validator: (value) {
                  if (value == null) {
                    return 'من فضلك ادخل كلمة المرور ';
                  } else if (value.length < AppConstants.passwordLength) {
                    return 'كلمة المرور لا يجب أن تقل عن ثمانية أحرف';
                  } else if (!value.contains(RegExp(r'[A-Z]'))) {
                    return 'كلمة المرور يجب أن تحتوي على أحرف كبيرة';
                  } else if (!value.contains(RegExp(r'[a-z]'))) {
                    return 'كلمة المرور يجب أن تحتوي على أحرف صغيرة';
                  } else if (!value.contains(RegExp(r'[0-9]'))) {
                    return 'كلمة المرور يجب أن تحتوي على أرقام';
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
                padding: EdgeInsets.only(top: size.height / 15),
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {}
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: LightThemeColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular((size.width > 400) ? 20 : 15),
                      )),
                  child: Text(
                    "تسجيل الدخول",
                    style: TextStyle(
                        fontSize: (size.width > 400) ? 30 : 20,
                        fontFamily: AppFonts.mainArabicFontFamily,
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'أو قم بتسجيل الدخول من خلال',
                style: TextStyle(
                  fontFamily: AppFonts.mainArabicFontFamily,
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
