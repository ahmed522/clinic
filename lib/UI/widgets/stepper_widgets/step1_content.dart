import 'dart:io';

import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../global/constants/app_constants.dart';
import '../../../global/theme/colors/light_theme_colors.dart';
import '../../../global/theme/fonts/app_fonst.dart';
import '../../../global/widgets/alert_dialog.dart';
import '../../../global/widgets/image_source_page.dart';

// ignore: must_be_immutable
class Step1Content extends StatefulWidget {
  UserType userType;
  bool imageIsSet = false;
  void Function()? validateImage;

  final formKey = GlobalKey<FormState>();
  Step1Content({super.key, this.userType = UserType.doctor});
  @override
  State<Step1Content> createState() => _Step1ContentState();
}

class _Step1ContentState extends State<Step1Content> {
  bool _showPassword = false;
  String pleaseEnterPicture = '';
  late GlobalKey<FormState> formKey;
  XFile? personalImage;
  final ImageSourcePage _imageSourcePage = ImageSourcePage();

  @override
  void initState() {
    super.initState();
    formKey = widget.formKey;

    _imageSourcePage.onPressed = (image) => setState(() {
          personalImage = image;
          if (personalImage != null) {
            widget.imageIsSet = true;
          }
          setState(() {
            pleaseEnterPicture = '';
          });
        });
    widget.validateImage = () {
      setState(() {
        pleaseEnterPicture = 'من فضلك أدخل الصورة الشخصية';
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Padding(
          padding: (widget.userType == UserType.doctor)
              ? const EdgeInsets.only(top: 20, right: 25, left: 25)
              : const EdgeInsets.only(top: 70, right: 40, left: 40),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MyAlertDialog.getInfoAlertDialog(
                    context,
                    'الصورة الشخصية',
                    AppConstants.whyPersonalImage,
                    {
                      'أعي ذلك': () => Navigator.of(context).pop(),
                    },
                  ),
                  const Text(
                    ' الصورة الشخصية',
                    style: TextStyle(
                      fontFamily: AppFonts.mainArabicFontFamily,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: LightThemeColors.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Stack(children: [
                (personalImage != null)
                    ? Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: LightThemeColors.primaryColor,
                              width: 3,
                            ),
                            shape: BoxShape.circle),
                        child: CircleAvatar(
                          backgroundImage: FileImage(File(personalImage!.path)),
                          radius: 80,
                        ),
                      )
                    : Image.asset('assets/img/user_pic.png'),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: LightThemeColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: IconButton(
                          padding: const EdgeInsets.all(0),
                          iconSize: 25,
                          onPressed: () {
                            showModalBottomSheet<dynamic>(
                              enableDrag: false,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(35))),
                              context: context,
                              builder: (context) => Padding(
                                padding: MediaQuery.of(context).viewInsets,
                                child: Wrap(children: [
                                  _imageSourcePage,
                                ]),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add, color: Colors.white)),
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 20),
              (widget.userType == UserType.doctor)
                  ? Text(
                      pleaseEnterPicture,
                      style: const TextStyle(
                        fontFamily: AppFonts.mainArabicFontFamily,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Colors.red,
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(height: 40),
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
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MyAlertDialog.getInfoAlertDialog(
                    context,
                    'يجب أن تحتوي كلمة المرور على الاتي ',
                    AppConstants.passwordRequirements,
                    {
                      'أعي ذلك': () => Navigator.of(context).pop(),
                    },
                  ),
                  const Text(
                    'كلمة المرور',
                    style: TextStyle(
                      fontFamily: AppFonts.mainArabicFontFamily,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: LightThemeColors.primaryColor,
                    ),
                  ),
                ],
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
                obscureText: !_showPassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  icon: const Icon(Icons.password_rounded),
                  hintText: 'Enter your Password',
                  suffixIcon: IconButton(
                    icon: (_showPassword)
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MyAlertDialog.getInfoAlertDialog(
                    context,
                    'الإسم الأول',
                    AppConstants.userNameRequirements,
                    {
                      'أعي ذلك': () => Navigator.of(context).pop(),
                    },
                  ),
                  const Text(
                    'الإسم الأول',
                    style: TextStyle(
                      fontFamily: AppFonts.mainArabicFontFamily,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: LightThemeColors.primaryColor,
                    ),
                  ),
                ],
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'من فضلك ادخل الاسم  ';
                  } else if (value.contains(RegExp(r'[0-9]'))) {
                    return 'الاسم لا يجب ان يحتوي على أرقام';
                  }

                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'First name',
                  icon: Icon(Icons.person),
                  hintText: 'Enter your first name',
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MyAlertDialog.getInfoAlertDialog(
                    context,
                    'الإسم الأخير',
                    AppConstants.userNameRequirements,
                    {
                      'أعي ذلك': () => Navigator.of(context).pop(),
                    },
                  ),
                  const Text(
                    'الإسم الأخير',
                    style: TextStyle(
                      fontFamily: AppFonts.mainArabicFontFamily,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: LightThemeColors.primaryColor,
                    ),
                  ),
                ],
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'من فضلك ادخل الاسم ';
                  } else if (value.contains(RegExp(r'[0-9]'))) {
                    return 'الاسم لا يجب ان يحتوي على أرقام';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Last name',
                  icon: Icon(Icons.person),
                  hintText: 'Enter your last name',
                ),
              ),
              const SizedBox(height: 50),
              (widget.userType == UserType.user)
                  ? Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (widget.formKey.currentState!.validate()) {
                              MySnackBar.showSnackBar(
                                  context, 'تم التسجيل بنجاح');
                            }
                          },
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
                          height: 30,
                        ),
                      ],
                    )
                  : const SizedBox(),
              const Text(
                'أو قم بالتسجيل من خلال',
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
                padding: const EdgeInsets.only(top: 20, bottom: 40),
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
