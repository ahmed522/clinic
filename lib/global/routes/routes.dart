import 'package:clinic/features/authentication/pages/sign_up/doctor/doctor_signup_parent.dart';
import 'package:clinic/features/authentication/pages/sign_up/user/user_signup_page.dart';
import 'package:clinic/features/medical_record/pages/medical_record_page.dart';
import 'package:clinic/features/main_page/pages/main_page.dart';
import 'package:clinic/features/time_line/pages/post/user_post/create_user_post/create_user_post.dart';
import 'package:flutter/material.dart';
import 'package:clinic/features/start/pages/start_page.dart';

Map<String, WidgetBuilder> routes = {
  MainPage.route: (context) => const MainPage(),
  StartPage.route: (context) => const StartPage(),
  DoctorSignUpParent.route: (context) => const DoctorSignUpParent(),
  UserSignupPage.route: (context) => const UserSignupPage(),
  CreateUserPost.route: (context) => const CreateUserPost(),
  MedicalRecordPage.route: (context) => const MedicalRecordPage(),
};
