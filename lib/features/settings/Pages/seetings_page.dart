import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
        centerTitle: true,
      ),
      body: Center(
          child: ElevatedButton(
        child: Text(
          'تسجيل الخروج',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        onPressed: () {
          FirebaseAuth.instance.signOut();
        },
      )),
    );
  }
}
