import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/circle_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ClinicPhoneNumberListTile extends StatelessWidget {
  const ClinicPhoneNumberListTile({super.key, required this.phoneNumber});
  final String phoneNumber;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.numbers_rounded),
      title: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          phoneNumber,
          style: const TextStyle(
            fontFamily: AppFonts.mainArabicFontFamily,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      trailing: CircleButton(
        onPressed: () async {
          Uri phoneUrl = Uri(
            scheme: 'tel',
            path: phoneNumber,
          );
          if (await canLaunchUrl(phoneUrl)) {
            launchUrl(
              phoneUrl,
              mode: LaunchMode.externalApplication,
            );
          } else {
            CommonFunctions.errorHappened();
          }
        },
        backgroundColor: Colors.green,
        shadowColor: Colors.lightGreen,
        elevation: 2,
        child: const Icon(
          Icons.phone_rounded,
          color: Colors.white,
          size: 25,
        ),
      ),
    );
  }
}
