import 'package:clinic/features/authentication/pages/sign_up/doctor/doctor_signup_page.dart';
import 'package:clinic/global/widgets/default_appbar.dart';
import 'package:clinic/global/widgets/offline_page_builder.dart';
import 'package:flutter/material.dart';

class DoctorSignUpParent extends StatelessWidget {
  const DoctorSignUpParent({super.key});
  static const route = '/doctorSignupParentPage';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: DefaultAppBar(
        title: 'التسجيل',
      ),
      body: OfflinePageBuilder(child: DoctorSignupPage()),
    );
  }
}
