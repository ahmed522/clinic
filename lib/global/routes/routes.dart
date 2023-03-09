import 'package:clinic/presentation/Providers/injection_widgets/doctor_provider_injection_widget.dart';
import 'package:clinic/presentation/Providers/injection_widgets/user_provider_injection_widget.dart';
import 'package:flutter/material.dart';

import 'package:clinic/presentation/pages/doctor_signup_page.dart';
import 'package:clinic/presentation/pages/start_page.dart';
import 'package:clinic/presentation/pages/user_signup_page.dart';

Map<String, WidgetBuilder> routes = {
  StartPage.route: (context) => const StartPage(),
  DoctorSignupPage.route: (context) => const DoctorSignupPage(),
  UserSignupPage.route: (context) => const UserSignupPage(),
  DoctorProviderInjectionWidget.route: (context) =>
      const DoctorProviderInjectionWidget(),
  UserProviderInjectionWidget.route: (context) =>
      const UserProviderInjectionWidget(),
};
