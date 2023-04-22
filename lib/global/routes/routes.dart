import 'package:clinic/features/authentication/pages/sign_up/doctor/doctor_signup_page.dart';
import 'package:clinic/features/authentication/pages/sign_up/user/user_signup_page.dart';
import 'package:clinic/presentation/pages/main_page.dart';
import 'package:clinic/features/time_line/pages/post/user_post/post_page.dart';
import 'package:clinic/features/time_line/pages/post/user_post/create_user_post.dart';
import 'package:clinic/global/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:clinic/features/start/pages/start_page.dart';

Map<String, WidgetBuilder> routes = {
  MainPage.route: (context) => const MainPage(),
  StartPage.route: (context) => const StartPage(),
  DoctorSignupPage.route: (context) => DoctorSignupPage(),
  UserSignupPage.route: (context) => UserSignupPage(),
  CreateUserPost.route: (context) => const CreateUserPost(),
  PostPage.route: (context) => const PostPage(),
  Loading.route: (context) => const Loading(),
};