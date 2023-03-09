import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/presentation/Providers/inherited_widgets/parent_user_provider.dart';
import 'package:clinic/presentation/pages/doctor_signup_page.dart';
import 'package:flutter/material.dart';

class DoctorProviderInjectionWidget extends StatelessWidget {
  const DoctorProviderInjectionWidget({super.key});
  static const route = '/doctorProviderInjectionWidget';

  @override
  Widget build(BuildContext context) {
    return ParentUserProvider(
      userType: UserType.doctor,
      child: const DoctorSignupPage(),
    );
  }
}
