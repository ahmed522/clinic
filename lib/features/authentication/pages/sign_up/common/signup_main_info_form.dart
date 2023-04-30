import 'package:clinic/features/authentication/controller/sign_up/common/signup_controller.dart';
import 'package:clinic/features/authentication/controller/sign_up/doctor/doctor_signup_controller.dart';
import 'package:clinic/features/authentication/controller/sign_up/user/user_signup_controller.dart';
import 'package:clinic/features/authentication/pages/sign_up/common/gender_selector.dart';
import 'package:clinic/features/authentication/pages/sign_up/doctor/doctor_signup_parent.dart';
import 'package:clinic/features/authentication/pages/sign_up/user/user_signup_page.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/constants/app_constants.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/fonts/app_fonst.dart';
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
                  child: Text(
                    'العمر',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 90, left: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        validator: ((value) {
                          if (value == null || value.trim().isEmpty) {
                            if (userType == UserType.doctor) {
                              (controller as DoctorSignupController)
                                  .updateAge(AppConstants.wrongAgeErrorCode);
                            } else {
                              (controller as UserSignupController)
                                  .updateAge(AppConstants.wrongAgeErrorCode);
                            }
                            return 'من فضلك ادخل العمر  ';
                          } else if (!RegExp(
                                  AppConstants.vezeetaValidationRegExp)
                              .hasMatch(value)) {
                            if (userType == UserType.doctor) {
                              (controller as DoctorSignupController)
                                  .updateAge(AppConstants.wrongAgeErrorCode);
                            } else {
                              (controller as UserSignupController)
                                  .updateAge(AppConstants.wrongAgeErrorCode);
                            }
                            return 'من فضلك ادخل قيمة صحيحة ';
                          } else {
                            int enteredAge = int.parse(value);
                            int age = (userType == UserType.doctor)
                                ? AppConstants.doctorMinimumAge
                                : AppConstants.userMinimumAge;
                            if (enteredAge < age) {
                              if (userType == UserType.doctor) {
                                (controller as DoctorSignupController)
                                    .updateAge(AppConstants.wrongAgeErrorCode);
                              } else {
                                (controller as UserSignupController)
                                    .updateAge(AppConstants.wrongAgeErrorCode);
                              }

                              if (age == AppConstants.doctorMinimumAge) {
                                return 'الحد الأدنى لعمر الطبيب هو ${AppConstants.doctorMinimumAge} عام';
                              }
                              return 'الحد الأدنى لعمر المستخدم هو ${AppConstants.userMinimumAge} عام';
                            }

                            if (userType == UserType.doctor) {
                              (controller as DoctorSignupController)
                                  .updateAge(enteredAge);
                            } else {
                              (controller as UserSignupController)
                                  .updateAge(enteredAge);
                            }
                            return null;
                          }
                        }),
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                        decoration: const InputDecoration(
                          counter: Offstage(),
                        ),
                      ),
                      Container(
                        width: 20,
                        height: 5,
                        decoration: BoxDecoration(
                            color: (userType == UserType.doctor)
                                ? ((controller as DoctorSignupController)
                                            .doctorModel
                                            .age ==
                                        AppConstants.wrongAgeErrorCode)
                                    ? Colors.red
                                    : (Theme.of(context).brightness ==
                                            Brightness.light)
                                        ? AppColors.primaryColor
                                        : Colors.white
                                : ((controller as UserSignupController)
                                            .userModel
                                            .age ==
                                        AppConstants.wrongAgeErrorCode)
                                    ? Colors.red
                                    : (Theme.of(context).brightness ==
                                            Brightness.light)
                                        ? AppColors.primaryColor
                                        : Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                      ),
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
                ),
                (userType == UserType.user)
                    ? Column(
                        children: [
                          const SizedBox(height: 50),
                          ElevatedButton(
                            onPressed: () {
                              if ((controller as UserSignupController)
                                  .formKey
                                  .currentState!
                                  .validate()) {
                                controller.signupUser(controller.userModel);
                              }
                            },
                            style: ElevatedButton.styleFrom(
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
