import 'package:clinic/UI/pages/start_page.dart';
import 'package:clinic/UI/pages/user_signup_page.dart';
import 'package:flutter/material.dart';

import '../../UI/pages/doctor_signup_page.dart';

Map<String, WidgetBuilder> routes = {
  StartPage.route: (context) => const StartPage(),
  DoctorSignupPage.route: (context) => const DoctorSignupPage(),
  UserSignupPage.route: (context) => UserSignupPage(),
};
