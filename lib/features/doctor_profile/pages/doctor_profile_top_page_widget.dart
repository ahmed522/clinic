import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/page_top_widget.dart';
import 'package:flutter/material.dart';

class DoctorProfileTopPageWidget extends StatelessWidget {
  const DoctorProfileTopPageWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Positioned(
          right: 100,
          top: 40,
          child: SizedBox(
            width: (size.width > 350) ? 100 : 80,
            height: (size.width > 350) ? 100 : 80,
            child: Image.asset(
              CommonFunctions.isLightMode(context)
                  ? 'assets/img/doctor-profile-page-icon-black.png'
                  : 'assets/img/doctor-profile-page-icon-white.png',
            ),
          ),
        ),
        TopPageWidget(height: size.height / 4),
      ],
    );
  }
}
