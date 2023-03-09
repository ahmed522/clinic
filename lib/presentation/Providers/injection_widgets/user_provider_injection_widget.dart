import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/presentation/Providers/inherited_widgets/parent_user_provider.dart';
import 'package:clinic/presentation/pages/user_signup_page.dart';
import 'package:flutter/material.dart';

class UserProviderInjectionWidget extends StatelessWidget {
  const UserProviderInjectionWidget({super.key});
  static const route = '/userProviderInjectionWidget';

  @override
  Widget build(BuildContext context) {
    return ParentUserProvider(
      userType: UserType.user,
      child: const UserSignupPage(),
    );
  }
}
