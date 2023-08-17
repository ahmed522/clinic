import 'package:clinic/features/authentication/controller/sign_up/common/signup_controller.dart';
import 'package:clinic/features/authentication/controller/sign_up/doctor/doctor_signup_controller.dart';
import 'package:clinic/features/authentication/controller/sign_up/user/user_signup_controller.dart';
import 'package:clinic/features/authentication/pages/sign_up/common/gender_selector.dart';
import 'package:clinic/features/authentication/pages/sign_up/doctor/doctor_signup_parent.dart';
import 'package:clinic/features/authentication/pages/sign_up/user/user_signup_page.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupMainInfoForm extends StatelessWidget {
  const SignupMainInfoForm({
    Key? key,
    required this.userType,
  }) : super(key: key);

  final UserType userType;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GetBuilder<SignupController>(
        tag: userType == UserType.doctor
            ? DoctorSignUpParent.route
            : UserSignupPage.route,
        builder: (controller) {
          return Form(
            key: controller.formKey,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MyAlertDialog.getInfoAlertDialog(
                        context,
                        'تاريخ الميلاد',
                        (userType == UserType.user)
                            ? AppConstants.userBirthDateRequirements
                            : AppConstants.doctorBirthDateRequirements,
                        {
                          'أعي ذلك': () => Get.back(),
                        },
                      ),
                      Text(
                        'تاريخ الميلاد',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: controller.loading
                            ? null
                            : () => (userType == UserType.user)
                                ? (controller as UserSignupController)
                                    .pickBirthDate(context)
                                : (controller as DoctorSignupController)
                                    .pickBirthDate(context),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.date_range_rounded),
                            SizedBox(width: size.width > 320 ? 5.0 : 0.0),
                            size.width > 320
                                ? Text(
                                    'أدخل تاريخ الميلاد',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      controller.ageIsValid
                          ? const Icon(Icons.done_rounded, color: Colors.green)
                          : const Icon(
                              Icons.close_rounded,
                              color: Colors.red,
                            )
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                GenderSelectorWidget(
                  userType: userType,
                ),
                const SizedBox(height: 40),
                const Divider(
                  thickness: 2,
                  indent: 80,
                  endIndent: 80,
                ),
                const SizedBox(height: 40),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'البريد الإلكتروني',
                    style: Theme.of(context).textTheme.bodyText1,
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
                        return 'من فضلك ادخل بريد إلكتروني صحيح';
                      }
                    }
                    if (userType == UserType.doctor) {
                      (controller as DoctorSignupController).doctorModel.email =
                          value;
                    } else {
                      (controller as UserSignupController).userModel.email =
                          value;
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
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
                    Text(
                      'كلمة المرور',
                      style: Theme.of(context).textTheme.bodyText1,
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
                    if (userType == UserType.doctor) {
                      (controller as DoctorSignupController)
                          .doctorModel
                          .setPassword = value;
                    } else {
                      (controller as UserSignupController)
                          .userModel
                          .setPassword = value;
                    }

                    return null;
                  },
                  obscureText: !controller.showPassword,
                  keyboardType: TextInputType.visiblePassword,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    icon: const Icon(Icons.password_rounded),
                    hintText: 'Enter your Password',
                    suffixIcon: IconButton(
                      icon: (controller.showPassword)
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off),
                      onPressed: () {
                        controller.updateShowPassword();
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
                    Text(
                      'الإسم الأول',
                      style: Theme.of(context).textTheme.bodyText1,
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
                    if (userType == UserType.doctor) {
                      (controller as DoctorSignupController)
                          .doctorModel
                          .firstName = value;
                    } else {
                      (controller as UserSignupController).userModel.firstName =
                          value;
                    }

                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'First name',
                    icon: Icon(Icons.person),
                    hintText: 'Enter your first name',
                  ),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
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
                    Text(
                      'الإسم الأخير',
                      style: Theme.of(context).textTheme.bodyText1,
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
                    if (userType == UserType.doctor) {
                      (controller as DoctorSignupController)
                          .doctorModel
                          .lastName = value;
                    } else {
                      (controller as UserSignupController).userModel.lastName =
                          value;
                    }

                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Last name',
                    icon: Icon(Icons.person),
                    hintText: 'Enter your last name',
                  ),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                ),
                (userType == UserType.user)
                    ? Column(
                        children: [
                          const SizedBox(height: 50),
                          ElevatedButton(
                            onPressed: controller.loading
                                ? null
                                : () => (controller as UserSignupController)
                                    .onSignupUserButtonPressed(),
                            style: ElevatedButton.styleFrom(
                                disabledBackgroundColor: Colors.grey,
                                backgroundColor: AppColors.primaryColor,
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
                    : const SizedBox(
                        height: 40,
                      ),
                // const SignWithGoogle(text: 'أو قم بالتسجيل من خلال'),
                // const SizedBox(height: 20),
              ],
            ),
          );
        });
  }
}
