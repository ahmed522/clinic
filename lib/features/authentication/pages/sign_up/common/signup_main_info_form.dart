import 'package:clinic/features/authentication/controller/sign_up/common/signup_controller.dart';
import 'package:clinic/features/authentication/controller/sign_up/doctor/doctor_signup_controller.dart';
import 'package:clinic/features/authentication/controller/sign_up/user/user_signup_controller.dart';
import 'package:clinic/features/authentication/pages/sign_up/common/gender_selector.dart';
import 'package:clinic/features/authentication/pages/sign_up/common/signup_email_text_field.dart';
import 'package:clinic/features/authentication/pages/sign_up/common/signup_name_text_field.dart';
import 'package:clinic/features/authentication/pages/sign_up/common/signup_password_text_field.dart';
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
                                  style: Theme.of(context).textTheme.bodyText1,
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
              GenderSelectorWidget(userType: userType),
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
              SignupEmailTextField(userType: userType),
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
              SignupPasswordTextField(userType: userType),
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
              SignupNameTextField(
                userType: userType,
                text: 'الأول',
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
              SignupNameTextField(
                userType: userType,
                text: 'الأخير',
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
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            "التسجيل",
                            style: TextStyle(
                              fontSize: 30,
                              fontFamily: AppFonts.mainArabicFontFamily,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    )
                  : const SizedBox(height: 40),
              // const SignWithGoogle(text: 'أو قم بالتسجيل من خلال'),
              // const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
